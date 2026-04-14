// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDAS0iVhADqBAb71bl-cYPOhIu2lfYjv9o",
  authDomain: "ecommerce-fbffb.firebaseapp.com",
  databaseURL: "https://ecommerce-fbffb-default-rtdb.firebaseio.com",
  projectId: "ecommerce-fbffb",
  storageBucket: "ecommerce-fbffb.firebasestorage.app",
  messagingSenderId: "454865683716",
  appId: "1:454865683716:web:0eee3c37ee9ffe35bffc51",
  measurementId: "G-GNSC205GH4"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);