<template>
  <div class="container">
    <!-- show error which could be closed -->
    <div class="alert alert-danger alert-dismissible fade show" role="alert" v-if="error">
      <strong>Error!</strong> {{ error }}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close" @click="error = ''">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <h1 v-if="role === 'Admin'">Admin Dashboard</h1>
    <h1 v-else>Manager Dashboard</h1>
    <h4 class="lead" v-if="role ==='Admin'">Welcome to the admin dashboard, Admin!</h4>
    <h4 class="lead" v-else>Welcome to the Store Manager dashboard, Manager!</h4>
    <hr>

    <div>
      <h3>
        <span>
          Products
          <button class="btn btn-success" style="margin-left: 70%;" @click="downloadProducts" v-if="products[0] && role === 'Storemanager'">Download Products</button>
        </span>
        <span v-if="isWaiting" class="spinner-border spinner-border-sm text-primary mx-1" role="status" aria-hidden="true"></span>
      </h3>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>Creator</th>
            <th>Quantity</th>
            <th>Manufacture Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody v-if="products[0]">
          <tr v-for="product in products">
            <td>{{ product.id }}</td>
            <td>{{ product.name }}</td>
            <td>{{ product.category.name }}</td>
            <td>{{ product.price }}</td>
            <td>{{ product.creator }}</td>
            <td>{{ product.quantity }}</td>
            <td>{{ product.manufacture_date }}</td>
            <td v-if="role === 'Storemanager'">
              <router-link :to="{ name: 'editproduct', params: { id: product.id } }" class="btn btn-primary mx-1 mb-1">Edit</router-link>
              <button class="btn btn-danger" @click="deleteProduct(product.id)" v-if="product.delete">Delete</button>
              <button class="btn btn-outline-danger" @click="deleteProduct(product.id)" v-else>Delete</button>
            </td>
            <td v-else-if="product.delete">
              <button class="btn btn-danger" @click="deleteProduct(product.id)">Delete</button>
            </td>
            <td v-else>
              <button class="btn btn-outline-danger" disabled>Delete</button>
            </td>
          </tr>
        </tbody>
        <h3 v-else>
          <td colspan="5">No Products</td>
        </h3>
      </table>
    </div>
  </div>
</template>


<script>
import router from '@/router'

  export default {
    name: 'ShowProducts',
    data() {
        return {
            token: localStorage.getItem('token'),
            role: localStorage.getItem('role'),
            products: [],
            isWaiting: false,
            error: ''
        };
    },
    methods: {
        async getProducts() {
            const response = await fetch('http://localhost:5000/api/products', {
                method: 'GET',
                headers: {
                    'Authentication-Token': localStorage.getItem('token')
                }
            })
                .catch(error => console.log(error));
            const data = await response.json();
            if (response.ok) {
                this.products = data;
            }
            else {
                this.error = data.message;
            }
        },
        async deleteProduct(id) {
            const response = await fetch(`http://localhost:5000/api/product/${id}`, {
                method: 'DELETE',
                headers: {
                    'Authentication-Token': localStorage.getItem('token')
                }
            })
                .catch(error => console.log(error));
            const data = await response.json();
            if (response.ok) {
              this.getProducts();
              if (this.role === 'Storemanager') {
                alert('Request to delete product sent to admin');
              }
              else {
                alert('Product deleted successfully');
              }
            }
            else {
                this.error = data.message;
            }
        },


        async downloadProducts() {
          this.isWaiting = true;
          const response = await fetch('http://localhost:5000/download-csv', {
            method: 'GET',
            headers: {
                'Authentication-Token': localStorage.getItem('token')
            }
          })
          .catch(error => console.log(error));
          const data = await response.json();
          if (response.ok) {
            const taskId = data.task_id;
            const intv = setInterval(async () => {
              const csv_response = await fetch(`http://localhost:5000/get-csv/${taskId}`, {
                method: 'GET',
                headers: {
                    'Authentication-Token': localStorage.getItem('token')
                }
              })
              .catch(error => console.log(error));
              if (csv_response.ok) {
                this.isWaiting = false;
                clearInterval(intv);
                window.location.href = `http://localhost:5000/get-csv/${taskId}`;
              }
            }, 1000);
          }
          else {
              this.error = data.message;
              this.isWaiting = false;
          }
        }
    },
    async mounted() {
        this.getProducts();
    },
    components: { router }
}
</script>