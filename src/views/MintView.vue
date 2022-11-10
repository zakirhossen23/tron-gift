<template>
  <div class="mint-page p-4">
    <h3>Mint a Gift Card</h3>
    <div class="d-flex gap-5 justify-content-center m-3 m-lg-5 show-grid">
      <div class="d-flex">
        <div class="gift-card-container position-relative">
          <div class="d-flex gift-card-container-insde h-100 justify-content-sm-around w-100">
            <div class="d-block gift-card-insider-message position-relative">
              <div class="d-flex flex-column h-75 justify-content-center">
                <small style="font-family:Arial;font-size: 1rem;">{{ messageGiven }}</small>
              </div>
              <div class="align-items-center d-flex flex-column position-absolute" style="bottom:9px;width:225px;">
                <small class="fw-bold text-center text-muted"
                  style="bottom:20px;padding:0px;font-size:0.8rem;line-height:1.57;letter-spacing:0.00714em;">{{
                      nameGiven
                  }}</small>
                <small class="fw-bolder lh-base m-0 text-center"
                  style="bottom:20px;font-family:calibri;letter-spacing:0.00938em;color:rgb(158, 158, 158);text-align:center;font-size:0.5rem;">{{
                      walletAddress
                  }}</small>
              </div>
            </div>
            <div class="d-block gift-card-insider-amount position-absolute">
              <h4>TRX {{ amountGiven }}</h4>
            </div>
            <div class="align-items-center d-flex flex-column gift-card-insider-gift-image justify-content-center"><img
                src="https://th.bing.com/th/id/R.5de3ee8846b54b5bfefdb3f503693fec?rik=51mB3RmbhSK8Xw&amp;pid=ImgRaw&amp;r=0"
                class="gift-card-insider-image"></div>
          </div>
        </div>
      </div>
      <form class="mint-form-form" v-on:submit="FormSubmit">
        <div class="col-auto">
          <input type="text" class="form-control mint-form-input" v-model="recipientGiven" required
            placeholder="Recipient Wallet">
          <div class="form-text text-md-start">This is the wallet of the person who you want to send this <p>gift card
              to</p>
          </div>
        </div>
        <div class="input-group mb-3"><span class="input-group-text">TRX</span>
          <input required placeholder="Amount" class="form-control mint-form-input" v-model="amountGiven" type="text">
        </div>
        <div class="col-auto mb-3">
          <textarea class="form-control" rows="3" placeholder="Message" required v-model="messageGiven"
            style="height:73px;"></textarea>
        </div>
        <div class="col-auto mb-3">
          <input type="text" class="form-control" v-model="nameGiven" required placeholder="Write your name">
        </div>
        <button type="submit" id="submitBTN" class="btn btn-primary rounded-5 w-100 position-relative">
          <span class="button__text">Mint your Gift</span>
        </button>
      </form>
    </div>
    <div class="ms-5 text-md-start">
      <h3>Gift you sent</h3>
    </div>
    <div class="d-flex flex-wrap m-3 m-lg-5 show-grid">
      <div class="d-flex flex-wrap gap-5 show-grid" v-if="sentGifts[0]?.name !== '' && sentGifts.length !== 0">
        <div class="d-flex" v-for="(value, index) in sentGifts" :key="index">
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
              <div class="align-items-center d-flex flex-column gift-card-insider-gift-image justify-content-center">
                <img
                  src="https://th.bing.com/th/id/R.5de3ee8846b54b5bfefdb3f503693fec?rik=51mB3RmbhSK8Xw&amp;pid=ImgRaw&amp;r=0"
                  class="gift-card-insider-image"></div>
            </div>
          </div>
        </div>
      </div>
      <div class="alert alert-primary text-start w-100" v-if="(!isRunning && sentGifts.length === 0) || (!isRunning && sentGifts[0]?.name === '') ">
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
  name: 'MintView',
  components: {},
  data: () => {
    return {
      amountGiven: 0,
      recipientGiven: "",
      messageGiven: "(Write your message)",
      nameGiven: "Write your name",
      walletAddress: window?.tronWeb?.defaultAddress?.base58,
      isRunning: false,
      sentGifts: [{
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
    async getSentGifts() {
      this.isRunning = true;
      if (contract.contract !== null) {
        this.sentGifts = [];
        let allSentsGifts = await contract.contract.getAllGiftCardBySentAddress(window?.tronWeb?.defaultAddress?.base58).call();
        for (let i = 0; i < allSentsGifts.length; i++) {
          const element = Number(allSentsGifts[i]);
          let giftItem = await contract.contract._giftMap(element).call();
          this.sentGifts.push({
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

    changeMessage(e: any) {
      this.messageGiven = e.target.value;
    },
    changeName(e: any) {
      this.nameGiven = e.target.value;
    },
    async clearFieds() {
      this.amountGiven = 0;
      this.recipientGiven = "";
      this.messageGiven = "(Write your message)";
      this.nameGiven = "Write your name";
    },

    async FormSubmit(e: any) {
      e.preventDefault();
      var BTN = document.querySelector("#submitBTN");
      BTN?.classList.add("button--loading");
      BTN?.classList.add("disabled");

      toast.info("Minting Gift Card", {
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
        let AmountinFull = (Number(this.amountGiven) * 1000000).toLocaleString('fullwide', { useGrouping: false });
      // Creating in Smart Contract
      await contract.contract.mintGift(this.walletAddress, this.recipientGiven, this.messageGiven, this.nameGiven).send({
        callValue: AmountinFull,
        feeLimit: 1_000_000_000,
        shouldPollResponse: false
      })

      toast.success("Minted gift card successfully!", {
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
      this.clearFieds();
      this.getSentGifts();
      } catch (error) {
        toast.error("Minting Gift Card Failed", {
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
      if (this.sentGifts[0]?.signedBy == "" && !this.isRunning) this.getSentGifts();
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
