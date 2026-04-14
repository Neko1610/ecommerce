import React from 'react';
import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
      <Toaster
        position="top-right"
        toastOptions={{
          duration: 3200,
          style: {
            borderRadius: '18px',
            background: '#0f172a',
            color: '#f8fafc',
            boxShadow: '0 18px 50px rgba(15, 23, 42, 0.24)',
          },
        }}
      />
    </BrowserRouter>
  </React.StrictMode>,
);
