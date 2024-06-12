<template>
  <div class="container">
    <div class="alert alert-danger alert-dismissible fade show" role="alert" v-if="error">
      <strong>Error!</strong> {{ error }}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close" @click="error = ''">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>

    <div class="row" v-for="category in categories" :key="category.id">
      <div class="col mb-4" v-if="category.active">
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">{{ category.name }}</h3>
            <!-- <p class="card-text">{{ category.description }}</p>  -->
          </div>
          <div class="card-body">
            <div class="row" v-if="category.products[0]">
              <div class="col-md-3" v-for="product in category.products" :key="product.id">
                <div class="card">
                  <div class="card-body">
                    <h4 class="card-title">{{ product.name }}</h4>
                    <p class="cart-text">Price: &#8377;{{ product.price }}</p>
                    <p class="card-text">Manufacture Date: {{ product.manufacture_date }}</p>
                    <p class="card-text" v-if="product.quantity">Available Quantity: {{ product.quantity }}</p>
                    <p class="card-text" v-else><strong class="text-danger">Out of Stock</strong></p>
                    <input type="number" class="form-control mb-3" v-model.number="cart[product.id]" min="1" v-if="product.quantity" :max="product.quantity">
                    <input type="number" class="form-control mb-3" v-else disabled>
                    <button class="btn btn-primary" v-if="product.quantity" @click="addToCart(cart[product.id], product.id, product.name)">Add to Cart</button>
                    <button class="btn btn-outline-primary" v-else disabled>Add to Cart</button>
                  </div>
                </div>
              </div>
            </div>
            <h3 v-else>No Products Available</h3>
          </div>
        </div>
      </div>
    </div>
    
  </div>
</template>


<script>
  export default {
    name: 'Home',

    data() {
      return {
        categories: [],
        products: [],
        cart: [], 
        error: ''
      }
    },

    methods: {
      async getCategories() {
        const response = await fetch('http://localhost:5000/api/categories', {
          method: 'GET',
          headers: {
            'Authentication-Token': localStorage.getItem('token')
          }
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.categories = data
        } else {
          console.log(data.message)
          this.error = data.message
        }
      },

      async addToCart(quantity, product_id, product_name) {
        const response = await fetch('http://localhost:5000/api/cart-item', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authentication-Token': localStorage.getItem('token')
          },
          body: JSON.stringify({
            quantity,
            product_id
          })
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.cart = data
          if (quantity === 1) alert(`Added ${quantity} item of product ${product_name} to cart`)
          else alert(`Added ${quantity} items of product ${product_name} to cart`)
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