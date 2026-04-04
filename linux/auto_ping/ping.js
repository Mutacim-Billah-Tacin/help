// ==UserScript==
// @name         Google Chat Auto Ping
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Auto sends Start → W every 4s → End after 20s
// @author       Tacin
// @match        https://chat.google.com/*
// @grant        none
// ==/UserScript==

(function () {
  'use strict';

  // ─── CONFIG ───────────────────────────────────────────
  const INTERVAL_MS   = 4000;   // W every 4 seconds
  const TOTAL_MS      = 20000;  // End after 20 seconds
  // ──────────────────────────────────────────────────────

  function getInputBox() {
    return document.querySelector('div[contenteditable="true"][role="textbox"]');
  }

  function sendMessage(text) {
    const box = getInputBox();
    if (!box) {
      console.warn('[AutoPing] Input box not found!');
      return;
    }

    box.focus();

    // Insert text via execCommand (works best with contenteditable)
    document.execCommand('selectAll', false, null);
    document.execCommand('delete', false, null);
    document.execCommand('insertText', false, text);

    // Small delay then press Enter
    setTimeout(() => {
      box.dispatchEvent(new KeyboardEvent('keydown', {
        bubbles: true, cancelable: true,
        key: 'Enter', code: 'Enter', keyCode: 13
      }));
    }, 100);
  }

  function startAutoPing() {
    console.log('[AutoPing] Starting...');

    // Step 1: Send 'Start'
    sendMessage('Start');

    let elapsed = 0;
    let pingStopped = false;

    // Step 2: Send 'W' every 4 seconds
    const interval = setInterval(() => {
      elapsed += INTERVAL_MS;

      if (elapsed >= TOTAL_MS) {
        if (!pingStopped) {
          pingStopped = true;
          clearInterval(interval);

          // Step 3: Send 'End'
          sendMessage('End');
          console.log('[AutoPing] Done.');
        }
        return;
      }

      sendMessage('W');
    }, INTERVAL_MS);
  }

  // ─── UI BUTTON ────────────────────────────────────────
  function createButton() {
    const btn = document.createElement('button');
    btn.textContent = '▶ Auto Ping';
    btn.title = 'Start → W (every 4s) → End (at 20s)';
    Object.assign(btn.style, {
      position:   'fixed',
      bottom:     '80px',
      right:      '20px',
      zIndex:     '9999',
      padding:    '10px 16px',
      background: '#1a73e8',
      color:      '#fff',
      border:     'none',
      borderRadius: '8px',
      cursor:     'pointer',
      fontWeight: 'bold',
      fontSize:   '14px',
      boxShadow:  '0 2px 8px rgba(0,0,0,0.3)'
    });

    btn.addEventListener('click', () => {
      btn.disabled = true;
      btn.textContent = '⏳ Running...';
      btn.style.background = '#888';

      startAutoPing();

      // Re-enable button after full cycle (20s + buffer)
      setTimeout(() => {
        btn.disabled = false;
        btn.textContent = '▶ Auto Ping';
        btn.style.background = '#1a73e8';
      }, TOTAL_MS + 1000);
    });

    document.body.appendChild(btn);
  }

  // Wait for page to load before injecting button
  window.addEventListener('load', () => {
    setTimeout(createButton, 2000);
  });

})();
