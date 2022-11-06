/* eslint-disable */
import "bootstrap/dist/css/bootstrap.css";
import "./assets/css/global.css";
import { createApp } from "vue";
import App from "./App.vue";
import Toast from "vue-toastification";
// Import the CSS or use your own!
import "vue-toastification/dist/index.css";

const app = createApp(App);


app.use(Toast, {});

createApp(App).use(router).mount("#app");


import "bootstrap/dist/js/bootstrap";
import router from './router'