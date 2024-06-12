<template>
  <div class="container">
    <!-- search based on query only -->
    <div class="input-group mb-4" style="width: 50%; margin-left: 25%;">
      <input type="text" class="form-control" placeholder="Search" v-model="query">
      <div class="input-group-append">
        <button class="btn btn-outline-secondary" type="button" @click="searchProduct">Search</button>
      </div>
    </div>
    <div class="row" v-if="products[0]">
      <div class="col-md-3" v-for="product in products" :key="product.id">
        <div class="card mb-4">
          <div class="card-body">
            <h4 class="card-title">{{ product.name }}</h4>
            <p class="cart-text">Price: &#8377;{{ product.price }}</p>
            <p class="card-text">Manufacture Date: {{ product.manufacture_date }}</p>
            <p class="card-text">Category: {{ product.category.name }}</p>
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
    <div class="row text-center" v-else-if="result">
      <h2>No Products Available</h2>
    </div>
  </div>
</template>


<script>
  export default {
    name: 'Search',

    data() {
      return {
        query: '',
        result: false,
        products: [],
        cart: []
      }
    },

    methods: {
      async searchProduct() {
        const response = await fetch(`http://localhost:5000/api/search/${this.query}`, {
          method: 'GET',
          headers: {
            'Authentication-Token': localStorage.getItem('token')
          }
        })
          .catch(error => console.log(error));
        const data = await response.json();
        if (response.ok) {
          this.products = data;
          this.result = true;
        }
        else {
          this.error = data.message;
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
          console.log(data.message)
          this.error = data.message
        }
      }
    }
  }
</script>