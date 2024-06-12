<template>
  <div class="container">
    <h1 class="mb-3">Orders</h1>
    <hr>
    <div class="alert alert-warning" role="alert" v-if="!orders.length">
      <h1>You have no orders</h1> 
    </div>
    <div v-for="order in orders">
      <p>
        <strong>Order ID</strong>: {{ order.id }}<br>
        <strong>Order Date</strong>: {{ order.date.slice(8, 10) + '-' + order.date.slice(5, 8) + order.date.slice(0, 4)}} at {{ order.date.slice(11, 16) }}<br>

      </p>
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>Product</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Subtotal</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in order.order_items" :key="item.id">
            <td>{{ item.name }}</td>
            <td>{{ item.quantity }}</td>
            <td>&#8377;{{ item.price }}</td>
            <td>&#8377;{{ item.price * item.quantity }}</td>
          </tr>
        </tbody>
      </table>
      <h3>Total: &#8377;{{ order.total_price }}</h3>
      <hr class="mb-5">
    </div>
  </div>
</template>


<script>
  export default {
    name: 'Orders',

    data() {
      return {
        token: localStorage.getItem('token'),
        role: localStorage.getItem('role'),
        orders: [],
        error: ''
      }
    },

    methods: {
      async getOrders() {
        const response = await fetch('http://localhost:5000/api/order', {
          method: 'GET',
          headers: {
            'Authentication-Token': localStorage.getItem('token')
          },
        })
        .catch(error => console.log(error))
        const data = await response.json()
        if (response.ok) {
          this.orders = data

          this.orders.forEach(order => {
            const totalOrderPrice = order.order_items.reduce((total, item) => total + item.price * item.quantity, 0);
            order.total_price = totalOrderPrice;
          });
        } else {
          console.log(data.message)
          this.error = data.message
        }
      }
    },

    created() {
      this.getOrders()
    }
  }
</script>