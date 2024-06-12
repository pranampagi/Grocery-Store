<template>
  <div class="container">
    <h1 v-if="role ==='Admin'">Admin Dashboard</h1>
    <h1 v-else>Manager Dashboard</h1>
    <h4 class="lead" v-if="role ==='Admin'">Welcome to the admin dashboard, Admin!</h4>
    <h4 class="lead" v-else>Welcome to the Store Manager dashboard, Manager!</h4>
    <hr>

    <div>
      <h2>Categories</h2> {{ error }}
      <table class="table table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Creator</th>
            <th>Actions</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody v-if="categories[0]">
          <tr v-for="category in categories">
            <td>{{ category.id }}</td>
            <td>{{ category.name }}</td>
            <td>{{ category.description }}</td>
            <td>{{ category.creator }}</td>
            <td>
              <router-link :to="{ name: 'editcategory', params: { id: category.id } }" class="btn btn-primary mx-1 mb-1">Edit</router-link>
              <button class="btn btn-danger" @click="deleteCategory(category.id)" v-if="category.delete">Delete</button>
              <button class="btn btn-outline-danger" @click="deleteCategory(category.id)" v-else>Delete</button>
            </td>
            <td v-if="category.active">
              <button class="btn btn-outline-success" disabled>Activated</button>
            </td>
            <td v-else-if="!category.active & role === 'Admin'">
              <button class="btn btn-success" @click="activateCategory(category.id)">Activate</button>
            </td>
            <td v-else-if="!category.active & role === 'Storemanager'">
              <button class="btn btn-warning" disabled>Pending</button>
            </td>
            
          </tr>
        </tbody>
        <h3 v-else>
          <td colspan="5">No Categories</td>
        </h3>
      </table>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'ShowCategories',

    data() {
      return {
        token: localStorage.getItem('token'),
        role: localStorage.getItem('role'),
        categories: [],
        error: ''
      }
    },

    methods: {
      async getCategories(){
        const response = await fetch('http://localhost:5000/api/categories', {
          method: "GET",
          headers: {
            'Authentication-Token': this.token
          }
        }).catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.categories = data
        } else {
          this.error = data.message
        }
      },

      async activateCategory(id) {
        const response = await fetch(`http://localhost:5000/activate/category/${id}`, {
          method: "PUT",
          headers: {
            'Authentication-Token': this.token
          }
        }).catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          alert('Category activated')
          this.getCategories()
        } else {
          this.error = data.message
        }
      },

      
      async deleteCategory(id) {
        const response = await fetch(`http://localhost:5000/api/category/${id}`, {
          method: "DELETE",
          headers: {
            'Authentication-Token': this.token
          }
        }).catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.getCategories()
          if (this.role === 'Storemanager') {
            alert('Request to delete category sent to admin')
          } else {
            alert('Category deleted successfully')
          }
        } else {
          this.error = data.message
        }
      }


    },

    async mounted () {
      this.getCategories()
    }
  }
</script>