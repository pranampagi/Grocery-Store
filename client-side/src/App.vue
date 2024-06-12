<template>
  <Navbar :key="hasChanged"/>
  <router-view/>
</template>

<script>
import Navbar from './components/Navbar.vue'
export default {
  name: 'App',

  components: {
    Navbar
  },

  data() {
    return {
      hasChanged: true
    }
  },

  watch: {
    $route(to, from) {
      this.hasChanged = !this.hasChanged
    }
  },


  // router.beforeEach((to, from, next) => {
  //   if (to.name !== 'Login' && !localStorage.getItem('token') ? true : false) next({ name: 'Login' })
  //   else next()
  // })
}
</script>
