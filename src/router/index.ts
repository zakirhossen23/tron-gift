import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

const routes: Array<RouteRecordRaw> = [
  {
    path: '/gift',
    // route level code-splitting
    component: () => {if ( window.location.pathname == '/gift')return import( '../views/MyGiftView.vue'); return import('../components/EmptyView.vue');}
  },
  {
    path: '/mint',
    // route level code-splitting
    component: () => {if ( window.location.pathname == '/mint')return import( '../views/MintView.vue'); return import('../components/EmptyView.vue');}
  },
  {
    path: '/',
    component: () =>{if (window.location.pathname == "/")return import( '../views/HomeView.vue'); return import('../components/EmptyView.vue');}
  },
 
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
