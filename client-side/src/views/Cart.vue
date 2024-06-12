<template>
  <div class="container">
    <h1 class="mb-3">Cart</h1>
    <div class="alert alert-warning" role="alert" v-if="!Object.keys(cart).length">
      <h1>Your cart is empty</h1> 
    </div>
    <div class="alert alert-danger alert-dismissible fade show" role="alert" v-if="error">
      <strong>Error!</strong> {{ error }}
      <button type="button" class="close" data-dismiss="alert" aria-label="Close" @click="error = ''">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="row mb-5" v-for="(index, category) in cart" :key="index">
      <div class="col-md-12">
        <div class="card">
          <div class="card-header">
            <h2 class="card-title">{{ category }}</h2>
          </div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-3" v-for="product in cart[category]" :key="product.id">
                  <div class="card">
                    <div class="card-body">
                      <h4 class="card-title">{{ product.name }}</h4>
                      <p class="card-text">Price: &#8377;{{ product.price }}</p>
                      <p class="card-text">Manufacture Date: {{ product.manufacture_date }}</p>
                      <p class="card-text" v-if="product.quantity">Quantity: {{ product.quantity }}</p>
                      <p class="card-text" v-else><strong class="text-danger">Out of Stock</strong></p>
                      <p class="card-text"><strong>Total: &#8377;{{ Math.round(product.price * product.quantity * 100) / 100 }}</strong></p>
                      <button class="btn btn-danger" @click="deleteCartItem(product.id)">Remove</button>
                    </div>
                    <div class="card-footer">
                      <div class="input-group">
                        <div class="input-group-prepend">
                          <button class="btn btn-outline-secondary" type="button" @click="updateCart(product.quantity - 1, product.id, product.quantity)">-</button>
                        </div>
                        <input type="text" class="form-control text-center" :value="product.quantity">
                        <div class="input-group-append">
                          <button class="btn btn-outline-secondary" type="button" @click="updateCart(product.quantity + 1, product.id, product.quantity)">+</button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
        </div>
      </div>
    </div>
    <h3 class="mb-5">
      Total: &#8377;{{ total }}
      <span class="float-right" v-if="Object.keys(cart).length"><button class="btn btn-primary"  style="margin-left: 75%;" @click="checkout">Checkout</button></span>
    </h3>
  </div>


</template>

<script>
  export default {
    name: 'Cart',

    data() {
      return {
        cart: [],
        total: 0,
        error: ''
      }
    },

    methods: {
      async getCart() {
        const response = await fetch('http://localhost:5000/api/cart', {
          method: 'GET',
          headers: {
            'Authentication-Token': localStorage.getItem('token')
          },
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.cart = data
          this.cart = this.cart.cart_items.reduce((result, item) => {
            const { category, ...productDetails } = item;

            if (!result[category]) {
              result[category] = [];
            }
            result[category].push(productDetails);
            return result;
          }, {});

          this.updateQuantity()
          this.total = Object.values(this.cart).flat().reduce((total, item) => total + item.price * item.quantity, 0);
          this.total = Math.round(this.total * 100) / 100
        } else {
          console.log(data.message)
          this.error = data.message
        }
      },

      async updateCart(quantity, cart_item_id, product_quantity) {
        // Set quantity to 1 if it is less than 1
        if (quantity < 1) quantity = 1

        const response = await fetch(`http://localhost:5000/api/cart-item/${cart_item_id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authentication-Token': localStorage.getItem('token')
          },
          body: JSON.stringify({
            product_id: cart_item_id,
            quantity
          })
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.cart = data
          await this.getCart()
        } else {
          console.log(data.message)
          this.error = data.message
        }
      },

      async deleteCartItem(cart_item_id) {
        const response = await fetch(`http://localhost:5000/api/cart-item/${cart_item_id}`, {
          method: 'DELETE',
          headers: {
            'Authentication-Token': localStorage.getItem('token')
          }
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.cart = data
          alert('Item removed from cart')
          await this.getCart()
        } else {
          console.log(data.message)
          this.error = data.message
        }
      },


      async checkout() {
        const response = await fetch('http://localhost:5000/api/order', {
          method: 'POST',
          headers: {
            'Authentication-Token': localStorage.getItem('token')
          }
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.cart = data
          alert('Order placed successfully')
          this.$router.push({ name: 'orders' })
        } else {
          console.log(data.message)
          this.error = data.message
        }
      },



      async updateQuantity() {
        const response = await fetch('http://localhost:5000/quantity', {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authentication-Token': localStorage.getItem('token')
          },
          body: JSON.stringify(this.cart)
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.cart = data
          this.$router.push({ name: 'cart' })
        } else {
          console.log(data.message)
          this.error = data.message
        }

      }
    },




    async mounted () {
      await this.getCart()
    },

    // async created () {
    //   await this.updateQuantity()
    // }
  }
</script>