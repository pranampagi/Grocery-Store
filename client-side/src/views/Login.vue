<template>
  <div class="container">
    <div class="content-section" style="width: 50%; margin-left: 25%;">
      <fieldset class="form-group">
        <legend class="border-bottom mb-4">Log In</legend>
        <div class="form-group mb-3">
          <label for="email" class="mb-2">Email address</label>
          <input type="email" v-model="credentials.email" class="form-control" id="email" placeholder="Enter email">
        </div>
        <div class="form-group mb-3">
          <label for="password" class="mb-2">Password</label>
          <input type="password" v-model="credentials.password" class="form-control" id="password" placeholder="Password">
        </div>
        <div class="form-group mb-3">
          <button type="submit" class="btn btn-outline-primary" @click="login">Login</button>
        </div>
        <div class="alert alert-danger" v-if="error">
          {{ error }}
        </div>
      </fieldset>
    </div>
  </div>
</template>


<script>
  export default {
    name: 'Login',

    data() {
      return {
        credentials: {
          email: '',
          password: ''
        },
        error: ''
      }
    },

    methods: {
      async login() {
        const response = await fetch('http://localhost:5000/user-login', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(this.credentials)
        })
        const data = await response.json()
        if (response.ok) {
          localStorage.setItem('token', data.token)
          localStorage.setItem('role', data.role)

          if (data.role === 'Storemanager') {
            this.$router.push({ name: 'showproducts' })
          } else if (data.role === 'Customer') {
            this.$router.push({ name: 'home' })
          } else {
            this.$router.push({ name: 'users' })
          }
        } else {
          this.error = data.message
        }
      }
    }
  }
</script>