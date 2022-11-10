<template>
  <div class="mint-page p-4">
    <h3>My Gift Cards</h3>

    <div class="d-flex flex-wrap m-3 m-lg-5 show-grid">
      <div class="d-flex flex-wrap gap-5 show-grid" v-if="myGifts[0]?.name !== '' && myGifts.length !== 0">
        <div class="d-flex" v-for="value in myGifts" :key="value.gift_id">
          <div class="gift-card-container position-relative">
            <div class="d-flex gift-card-container-insde h-100 justify-content-sm-around w-100">

              <div class="d-block gift-card-insider-message position-relative">
                <div class="d-flex flex-column h-75 justify-content-center"><small
                    style="font-family: Arial; font-size: 1rem;">{{ value.message }}</small></div>
                <div class="align-items-center d-flex flex-column position-absolute" style="bottom: 9px; width: 225px;">
                  <small class="fw-bold text-center text-muted"
                    style="bottom: 20px; padding: 0px; font-size: 0.8rem; line-height: 1.57; letter-spacing: 0.00714em;">{{
                        value.name
                    }}</small><small class="fw-bolder lh-base m-0 text-center"
                    style="bottom: 20px; font-family: calibri; letter-spacing: 0.00938em; color: rgb(158, 158, 158); text-align: center; font-size: 0.5rem;">{{
                        value.signedBy
                    }}</small>
                </div>
              </div>
              <div class="d-block gift-card-insider-amount position-absolute">
                <h4>TRX {{ value.amount / 1000000 }}</h4>
              </div>
              <div class="d-block position-absolute" style="top: 0.5rem;right: 0.5rem;">
                <button @click="(e) => { UnWrap(e.currentTarget, value.gift_id) }"
                  class="btn btn-light rounded-5 position-relative" v-if="!value.isUnwrapped">
                  <span>Unwrap Gift</span>
                </button>
                <button class="btn btn-light rounded-5 disabled" style="color: darkgrey;"
                  v-if="value.isUnwrapped">Unwrapped</button>
              </div>
              <div class="align-items-center d-flex flex-column gift-card-insider-gift-image justify-content-center">
                <img
                  src="https://th.bing.com/th/id/R.5de3ee8846b54b5bfefdb3f503693fec?rik=51mB3RmbhSK8Xw&amp;pid=ImgRaw&amp;r=0"
                  class="gift-card-insider-image">
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="alert alert-primary text-start w-100"
        v-if="(!isRunning && myGifts.length === 0) || (!isRunning && myGifts[0]?.name === '')">
        You have no Gifts
      </div>
      <div class="alert alert-primary text-start w-100" v-if="isRunning">
        Loading...
      </div>
    </div>

  </div>
</template>


<script lang="ts">
declare let window: any;
import { defineComponent } from 'vue';

import { useToast } from "vue-toastification";

const toast = useToast();

let contract: any = { contract: null, signerAddress: null };
async function getContract() {
  let useContract = await import("../contract/useContract");
  contract = await useContract.default();
  window.contract = contract;
}
getContract();


export default defineComponent({
  name: 'MyGiftView',
  components: {},
  data: () => {
    return {
      walletAddress: window?.tronWeb?.defaultAddress?.base58,
      isRunning: false,
      myGifts: [{
        amount: 0,
        gift_id: 0,
        isUnwrapped: false,
        message: "",
        name: "",
        owner_address: "",
        signedBy: ""
      }],
    }

  },
  methods: {
    async getmyGifts() {
      this.isRunning = true;
      if (contract.contract !== null) {
        this.myGifts = [];
        let allmyGifts = await window.contract.contract.getAllGiftCardOfOwner(window?.tronWeb?.defaultAddress?.base58).call();
        for (let i = 0; i < allmyGifts.length; i++) {
          const element = Number(allmyGifts[i]);
          let giftItem = await contract.contract._giftMap(element).call();
          this.myGifts.push({
            amount: Number(giftItem.amount),
            gift_id: Number(giftItem.gift_id),
            isUnwrapped: giftItem.isUnwrapped,
            message: giftItem.message,
            name: giftItem.name,
            owner_address: giftItem.owner_address,
            signedBy: giftItem.signedBy
          })
        }

      }
      this.isRunning = false;
    },

    getWalletAddress() {
      this.walletAddress = window?.tronWeb?.defaultAddress?.base58;
    },

    async UnWrap(BTN: any, gift_id: any) {
      BTN?.classList.add("button--loading");
      BTN?.classList.add("disabled");

      toast.info("Unwraping Gift Card", {
        position: "top-right",
        timeout: 5000,
        closeOnClick: true,
        pauseOnFocusLoss: false,
        pauseOnHover: false,
        draggable: true,
        draggablePercent: 0.6,
        showCloseButtonOnHover: false,
        hideProgressBar: false,
        closeButton: "button",
        icon: true,
        rtl: false
      });

      try {
        // Creating in Smart Contract
        await contract.contract.unwrapGiftCard(gift_id).send({
          feeLimit: 1_000_000_000,
          shouldPollResponse: false
        })
        toast.success("Unwrapped gift card successfully!", {
          position: "top-right",
          timeout: 5000,
          closeOnClick: true,
          pauseOnFocusLoss: false,
          pauseOnHover: false,
          draggable: true,
          draggablePercent: 0.6,
          showCloseButtonOnHover: false,
          hideProgressBar: false,
          closeButton: "button",
          icon: true,
          rtl: false
        });
        this.getmyGifts();
      } catch (error) {
        toast.error("Unwrapping Gift Card Failed", {
          position: "top-right",
          timeout: 5000,
          closeOnClick: true,
          pauseOnFocusLoss: false,
          pauseOnHover: false,
          draggable: true,
          draggablePercent: 0.6,
          showCloseButtonOnHover: false,
          hideProgressBar: false,
          closeButton: "button",
          icon: true,
          rtl: false
        });
      }



      BTN?.classList.remove("button--loading");
      BTN?.classList.remove("disabled");

    }

  },
  created() {
    setInterval(() => {
      if (this.myGifts[0]?.signedBy == "" && !this.isRunning) this.getmyGifts();
      this.getWalletAddress();
    }, 1500);
  },


});


</script>


<style>
.gift-card-container {
  width: 400px;
  height: 220px;
  user-select: none;
}

.gift-card-container-insde {
  background-color: rgb(33, 37, 41);
  color: white;
  border-radius: 10px;
}

.gift-card-insider-message {
  width: 238px;
  padding: 37px 0px 0px 13px;
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
