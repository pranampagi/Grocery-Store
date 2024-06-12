<template>
  <nav class="navbar navbar-expand-md navbar-dark bg-success mb-4">
  <div class="container">
    <router-link class="navbar-brand mr-4" :to="{ name: 'home'}" v-if="role === 'Customer'">Grocery Store</router-link>
    <a class="navbar-brand mr-4" href="#" v-else>Grocery Store</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarScroll" aria-controls="navbarScroll" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarScroll">
      <ul class="navbar-nav me-auto my-2 my-lg-0 navbar-nav-scroll" style="--bs-scroll-height: 100px;">
        <li class="nav-item">
          <router-link class="nav-link" aria-current="page" :to="{ name: 'home' }" v-if="role === 'Customer'">Home</router-link>
        </li>
        <li class="nav-item">
          <router-link class="nav-link" :to="{ name: 'search'}" v-if="role === 'Customer'">Search</router-link>
        </li>
        <li class="nav-item" v-if="role === 'Admin'">
          <router-link class="nav-link" :to="{ name: 'users'}">Users</router-link>
        </li>
        <li class="nav-item" v-if="role === 'Admin' || role === 'Storemanager'">
          <router-link class="nav-link" :to="{ name: 'showcategories'}">Categories</router-link>
        </li>
        <li class="nav-item" v-if="role === 'Admin' || role === 'Storemanager'">
          <router-link class="nav-link" :to="{ name: 'showproducts'}">Products</router-link>
        </li>
      </ul>
      <div class="d-flex">
        <ul class="navbar-nav">
          <li class="nav-item" v-if="role === 'Admin' || role === 'Storemanager'">
            <router-link class="nav-link" :to="{ name: 'createcategory'}">Add Category</router-link>
          </li>
          <li class="nav-item" v-if="role === 'Storemanager'">
            <router-link class="nav-link" :to="{ name: 'createproduct'}">Add Product</router-link>
          </li>
          <li class="nav-item" v-if="role === 'Customer'">
            <router-link class="nav-link" :to="{ name: 'cart'}">Cart</router-link>
          </li>
          <li class="nav-item" v-if="role === 'Customer'">
            <router-link class="nav-link" :to="{ name: 'orders'}">Orders</router-link>
          </li>
          <li class="nav-item" v-if="!is_login">
            <router-link class="nav-link" :to="{ name: 'registerstoremanager'}">Manager</router-link>
          </li>
          <li class="nav-item" v-if="!is_login">
            <router-link class="nav-link" :to="{ name: 'register'}">Register</router-link>
          </li>
          <li class="nav-item" v-if="is_login">
            <button class="nav-link" @click="logout">Logout</button>
          </li>
          <li class="nav-item" v-else>
            <router-link class="nav-link" :to="{ name: 'login'}">Login</router-link>
          </li>
        </ul>
      </div>
    </div>
  </div>
</nav>
</template>


<script>
import { computed } from 'vue'

  export default {
    name: 'Navbar',

    data() {
      return {
        has_changed: true,
        token: localStorage.getItem('token'),
        role: localStorage.getItem('role'),
        is_login: localStorage.getItem('token'),
        error: ''
      }
    },

    methods: {
      async logout() {
        const response = await fetch('http://localhost:5000/user-logout', {
          method: 'GET',
          headers: {
            'Authentication-Token': this.token
          }
        }).catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          localStorage.removeItem('token')
          localStorage.removeItem('role')
          this.$router.push({ name: 'login' })
        } else {
          this.error = data.message
        } 
      }
    },

    watch: {
      $route(to, from) {
        this.has_changed = !this.has_changed
      }
    }
    
  }
</script>