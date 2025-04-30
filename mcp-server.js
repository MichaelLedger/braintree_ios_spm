#!/usr/bin/env node

/**
 * Custom MCP server for Braintree iOS SPM
 * This server can be used to listen for webhook events from GitHub
 * and trigger updates to the SPM package.
 */

const http = require('http');
const https = require('https');
const { exec } = require('child_process');
const crypto = require('crypto');

// Configuration
const PORT = process.env.PORT || 3000;
const GITHUB_SECRET = process.env.GITHUB_SECRET || 'your-webhook-secret';
const BRAINTREE_REPO = 'braintree/braintree_ios';

// Create HTTP server
const server = http.createServer((req, res) => {
  if (req.method === 'POST' && req.url === '/webhook') {
    handleWebhook(req, res);
  } else {
    res.statusCode = 404;
    res.end('Not Found');
  }
});

// Handle GitHub webhook
function handleWebhook(req, res) {
  let body = '';
  
  req.on('data', chunk => {
    body += chunk.toString();
  });
  
  req.on('end', () => {
    // Verify webhook signature if secret is set
    if (GITHUB_SECRET !== 'your-webhook-secret') {
      const signature = req.headers['x-hub-signature-256'];
      if (!signature) {
        console.error('No signature provided');
        res.statusCode = 401;
        res.end('Unauthorized');
        return;
      }
      
      const hmac = crypto.createHmac('sha256', GITHUB_SECRET);
      const digest = 'sha256=' + hmac.update(body).digest('hex');
      if (signature !== digest) {
        console.error('Invalid signature');
        res.statusCode = 401;
        res.end('Unauthorized');
        return;
      }
    }
    
    try {
      const event = JSON.parse(body);
      const eventType = req.headers['x-github-event'];
      
      // Handle release events from Braintree iOS repo
      if (eventType === 'release' && event.repository.full_name === BRAINTREE_REPO && event.action === 'published') {
        const version = event.release.tag_name;
        console.log(`New Braintree iOS release detected: ${version}`);
        
        // Update the package
        updatePackage(version, event.release.assets)
          .then(() => {
            res.statusCode = 200;
            res.end('Webhook processed successfully');
          })
          .catch(err => {
            console.error('Error updating package:', err);
            res.statusCode = 500;
            res.end('Internal Server Error');
          });
      } else {
        console.log('Ignoring non-release event or event from different repository');
        res.statusCode = 200;
        res.end('Event ignored');
      }
    } catch (err) {
      console.error('Error processing webhook:', err);
      res.statusCode = 400;
      res.end('Bad Request');
    }
  });
}

// Update package with new Braintree version
function updatePackage(version, assets) {
  return new Promise((resolve, reject) => {
    // Find the XCFramework ZIP asset
    const xcframeworkAsset = assets.find(asset => 
      asset.name.endsWith('.xcframework.zip') && 
      asset.name.includes(`Braintree`)
    );
    
    if (!xcframeworkAsset) {
      return reject(new Error('XCFramework asset not found in release'));
    }
    
    const downloadUrl = xcframeworkAsset.browser_download_url;
    
    // Execute the update script
    exec(`./update-framework.sh ${version}`, (error, stdout, stderr) => {
      if (error) {
        console.error(`Error executing update script: ${error}`);
        return reject(error);
      }
      
      console.log(`Update script output: ${stdout}`);
      
      // Commit and push changes
      exec(`git add . && git commit -m "Update to Braintree iOS SDK ${version}" && git tag -a "v${version}" -m "Version ${version}" && git push origin main --tags`, (error, stdout, stderr) => {
        if (error) {
          console.error(`Error pushing changes: ${error}`);
          return reject(error);
        }
        
        console.log(`Changes pushed: ${stdout}`);
        resolve();
      });
    });
  });
}

// Start server
server.listen(PORT, () => {
  console.log(`MCP Server running on port ${PORT}`);
  console.log(`Listening for webhook events from ${BRAINTREE_REPO}`);
}); 