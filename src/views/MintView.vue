<template>
  <div class="mint-page p-4">
    <h3>Mint a Gift Card</h3>
    <div class="d-flex gap-5 justify-content-center m-3 m-lg-5 show-grid">
      <div class="d-flex">
        <div class="gift-card-container position-relative">
          <div class="d-flex gift-card-container-insde h-100 justify-content-sm-around w-100">
            <div class="d-block gift-card-insider-message position-relative">
              <div class="d-flex flex-column h-75 justify-content-center">
                <small style="font-family:Arial;">{{messageGiven}}</small>
              </div>
              <div class="align-items-center d-flex flex-column position-absolute" style="bottom:9px;width:225px;">
                <small class="fw-bold text-center text-muted" style="bottom:20px;padding:0px;font-size:0.8rem;line-height:1.57;letter-spacing:0.00714em;">{{nameGiven}}</small>
                <small class="fw-bolder lh-base m-0 text-center" style="bottom:20px;font-family:calibri;letter-spacing:0.00938em;color:rgb(158, 158, 158);text-align:center;font-size:0.5rem;">{{walletAddress}}</small>
              </div>
            </div>
            <div class="d-block gift-card-insider-amount position-absolute">
              <h4>TRX {{amountGiven}}</h4>
            </div>
            <div class="align-items-center d-flex flex-column gift-card-insider-gift-image justify-content-center"><img
                src="https://th.bing.com/th/id/R.5de3ee8846b54b5bfefdb3f503693fec?rik=51mB3RmbhSK8Xw&amp;pid=ImgRaw&amp;r=0"
                class="gift-card-insider-image"></div>
          </div>
        </div>
      </div>
      <form class="mint-form-form" v-on:submit="FormSubmit">
        <div class="col-auto">
          <input type="text" class="form-control mint-form-input" required v-on:input="changeRecipeint" placeholder="Recipient Wallet">
          <div class="form-text text-md-start">This is the wallet of the person who you want to send this <p>gift card to</p>
          </div>
        </div>
        <div class="input-group mb-3"><span class="input-group-text">TRX</span>
          <input required placeholder="Amount" class="form-control mint-form-input"  v-on:input="changeAmount" type="text"></div>
        <div class="col-auto mb-3">
          <textarea class="form-control" rows="3" placeholder="Message" v-on:input="changeMessage" required style="height:73px;"></textarea></div>
        <div class="col-auto mb-3"><input type="text" class="form-control" required v-on:input="changeName" placeholder="Your Name"></div>
        <button type="submit" id="submitBTN" class="btn btn-primary rounded-5 w-100 position-relative">
          <span class="button__text">Mint your Gift</span>
         </button>
      </form>
    </div>
  </div>
</template>


<script lang="ts">
declare let window: any;
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'TheHeader',
  components: {},
  data: () => {
    return {
      amountGiven: 0,
      recipientGiven: "",
      messageGiven: "(Write your message)",
      nameGiven: "Write your name",
      walletAddress: window?.tronWeb?.defaultAddress?.base58,
    }

  },
  methods: {

    getWalletAddress() {
      this.walletAddress = window?.tronWeb?.defaultAddress?.base58;
    },

    changeRecipeint(e:any){
      this.recipientGiven = e.target.value;
    },
    changeAmount(e:any){
      this.amountGiven = e.target.value;
    },
    changeMessage(e:any){
      this.messageGiven = e.target.value;
    },
    changeName(e:any){
      this.nameGiven = e.target.value;
    },
    async FormSubmit(e:any){
      e.preventDefault();
      var BTN = document.querySelector("#submitBTN");
      BTN?.classList.add("button--loading");
      BTN?.classList.add("disabled");
    }
    
  },
  created() {
    setTimeout(() => {
      this.getWalletAddress();
    }, 500);
  },


});


</script>


<style>
.gift-card-container {
  width: 400px;
  height: 220px;
}

.gift-card-container-insde {
  background-color: rgb(33, 37, 41);
  color: white;
  border-radius: 10px;
}

.gift-card-insider-message {
  width: 238px;
  padding: 13px 0px 0px 13px;
}

.gift-card-insider-amount {
  padding: 13px 0px 0px 13px;
  left: 0rem;
}

.gift-card-insider-gift-image {
  width: 183px;
}

.gift-card-insider-image {
  width: 160px;
  height: 160px;
  font-family: Arial;
}

.mint-form-form {
  min-width: 25rem;
}

.mint-form-input {
  height: 3rem;
}
</style>
