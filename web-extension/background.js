/**
 * Gmail Hotkey Sender - Background Service Worker
 * 
 * Handles keyboard shortcuts and manages extension state.
 * This is a starter implementation that requires Gmail API integration.
 */

// Extension state
let extensionState = {
  isAuthenticated: false,
  defaultRecipient: '',
  defaultSubject: '',
  defaultBody: '',
  lastSentEmail: null
};

// Load extension state from storage
chrome.storage.local.get(['extensionState'], (result) => {
  if (result.extensionState) {
    extensionState = { ...extensionState, ...result.extensionState };
  }
});

// Save extension state to storage
function saveState() {
  chrome.storage.local.set({ extensionState });
}

// Handle keyboard commands
chrome.commands.onCommand.addListener(async (command) => {
  console.log(`Command received: ${command}`);
  
  switch (command) {
    case 'compose-email':
      await handleComposeEmail();
      break;
    case 'send-email':
      await handleSendEmail();
      break;
    default:
      console.warn(`Unknown command: ${command}`);
  }
});

/**
 * Handle compose email command
 */
async function handleComposeEmail() {
  try {
    // Get the active tab
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    
    if (!tab) {
      console.error('No active tab found');
      return;
    }

    // Check if we're on Gmail
    if (tab.url && tab.url.includes('mail.google.com')) {
      // Inject script to compose email
      await chrome.scripting.executeScript({
        target: { tabId: tab.id },
        function: composeEmailInGmail,
        args: [extensionState.defaultRecipient, extensionState.defaultSubject, extensionState.defaultBody]
      });
    } else {
      // Open Gmail compose URL
      const composeUrl = `https://mail.google.com/mail/u/0/#compose?to=${encodeURIComponent(extensionState.defaultRecipient)}&subject=${encodeURIComponent(extensionState.defaultSubject)}&body=${encodeURIComponent(extensionState.defaultBody)}`;
      
      await chrome.tabs.create({ url: composeUrl });
    }
  } catch (error) {
    console.error('Error handling compose email:', error);
  }
}

/**
 * Handle send email command
 */
async function handleSendEmail() {
  try {
    // Get the active tab
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    
    if (!tab) {
      console.error('No active tab found');
      return;
    }

    // Check if we're on Gmail
    if (tab.url && tab.url.includes('mail.google.com')) {
      // Inject script to send email
      await chrome.scripting.executeScript({
        target: { tabId: tab.id },
        function: sendEmailInGmail
      });
    } else {
      console.warn('Not on Gmail page');
    }
  } catch (error) {
    console.error('Error handling send email:', error);
  }
}

/**
 * Function to be injected into Gmail page for composing email
 */
function composeEmailInGmail(recipient, subject, body) {
  // TODO: Implement Gmail compose automation
  console.log('Composing email in Gmail...');
  console.log('Recipient:', recipient);
  console.log('Subject:', subject);
  console.log('Body:', body);
  
  // This would interact with Gmail's compose interface
  // For now, just log the parameters
}

/**
 * Function to be injected into Gmail page for sending email
 */
function sendEmailInGmail() {
  // TODO: Implement Gmail send automation
  console.log('Sending email in Gmail...');
  
  // This would click the send button or trigger send action
  // For now, just log the action
}

// Handle extension installation
chrome.runtime.onInstalled.addListener((details) => {
  console.log('Gmail Hotkey Sender extension installed');
  
  if (details.reason === 'install') {
    // First time installation
    console.log('First time installation - setting up defaults');
    
    // Set default values
    extensionState = {
      isAuthenticated: false,
      defaultRecipient: '',
      defaultSubject: 'Quick Message',
      defaultBody: 'Hello,\n\nBest regards,\n[Your Name]',
      lastSentEmail: null
    };
    
    saveState();
  }
});

// Handle messages from popup or content scripts
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log('Message received:', request);
  
  switch (request.action) {
    case 'getState':
      sendResponse(extensionState);
      break;
      
    case 'updateState':
      extensionState = { ...extensionState, ...request.data };
      saveState();
      sendResponse({ success: true });
      break;
      
    case 'composeEmail':
      handleComposeEmail();
      sendResponse({ success: true });
      break;
      
    case 'sendEmail':
      handleSendEmail();
      sendResponse({ success: true });
      break;
      
    default:
      sendResponse({ error: 'Unknown action' });
  }
  
  return true; // Keep message channel open for async response
});

// Handle tab updates to detect Gmail pages
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === 'complete' && tab.url && tab.url.includes('mail.google.com')) {
    console.log('Gmail page loaded');
    
    // TODO: Inject content script or perform any Gmail-specific setup
  }
});

// Handle authentication (placeholder for future OAuth2 implementation)
async function authenticateWithGmail() {
  // TODO: Implement OAuth2 authentication with Gmail API
  console.log('Gmail API authentication not yet implemented');
  console.log('Please implement OAuth2 flow for Gmail API access');
  
  extensionState.isAuthenticated = false;
  saveState();
  
  return false;
}

// Export functions for testing (if needed)
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    handleComposeEmail,
    handleSendEmail,
    authenticateWithGmail
  };
}
