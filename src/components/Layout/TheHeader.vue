<template>
    <div>
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom">
            <div class="container-fluid">
                <a class="navbar-brand position-absolute" style="left: 1rem;" href="/">TronGift</a>

                <div id="navbarNav" class="d-flex justify-content-center w-100">
                    <ul class="navbar-nav">
                        <li :class="{ 'active': isPageMint }" class="nav-item">
                            <a class="nav-link " aria-current="page" href="/mint">Mint
                                a Gift Card</a>
                        </li>
                        <li :class="{ 'active': isPageGift }" class="nav-item">
                            <a class="nav-link " href="/gift">My Gift Card</a>
                        </li>
                    </ul>
                </div>

                <div v-if="isTronLinkConnected" id="ContainerWallet"
                style="background: rgb(239, 239, 239);padding: 0.8rem;right: 1rem;top: 4px;" 
                class="position-absolute rounded-5">
                    <div class="" style="display: flex;gap: 0.5rem;">
                        <img src="https://th.bing.com/th/id/OIP.SAZyRuAR859KOTNNGFVASwAAAA?pid=ImgDet&amp;rs=1"
                            width="20">
                        <!-- <span href="/" >TErF2SND...EUcZ</span> -->
                        <span >{{ walletAddress }}</span>
                    </div>
                </div>


                <div class="btn-group-toggle position-absolute"  style="right: 1rem;top: 7px;"  v-else-if="isTronLinkInstalled">
                    <button type="button" v-on:click="installTron()" class="btn btn-primary p-lg-2">Install TronLink</button>

                </div>

                <div class="btn-group-toggle position-absolute"  style="right: 1rem;top: 7px;"  v-else>
                    <button type="button" v-on:click="connectTron()"  class="btn btn-primary p-lg-2">Connect to TronLink</button>

                </div>

            </div>
        </nav>
    </div>

</template>

<script lang="ts">
declare let window: any;
import { defineComponent } from 'vue';
let contract: any = { contract: null, signerAddress: null };
async function getContract() {
    let contract2 = await import("../../contract/useContract");
    contract = contract2;
}
getContract();

export default defineComponent({
    name: 'TheHeader',
    components: {},
    data: () => {
        return {
            data: {},
            isPageMint: window.location.pathname == '/mint',
            isPageGift: window.location.pathname == '/gift',
            walletAddress: window?.tronWeb?.defaultAddress?.base58 ,
            isTronLinkInstalled: window?.tronLink === undefined,
            isTronLinkConnected: window?.tronWeb?.defaultAddress?.base58 != false && window?.tronWeb?.defaultAddress?.base58 != undefined
        }

    },
    methods: {
        getTronStatus() {
           this.getWalletAddress() ;
            this.isTronLinkInstalled = window?.tronLink === undefined;
            this.isTronLinkConnected =  window?.tronWeb?.defaultAddress?.base58 != false && window?.tronWeb?.defaultAddress?.base58 != undefined;
        },
        getWalletAddress(){
          this.walletAddress =  window?.tronWeb?.defaultAddress?.base58.toString().substr(0, 8) + "..." + window?.tronWeb?.defaultAddress?.base58.toString().substr(27, 8);
        },
        async connectTron() {
            let result = await window.tronWeb.request({ method: 'tron_requestAccounts' });
            result;
            this.getTronStatus();
        },
        async installTron() {
            window.open("https://chrome.google.com/webstore/detail/tronlink/ibnejdfjmmkpcnlpebklmnkoeoihofec","_blank");
        },
        

    },
    created() {
        setTimeout(() => {
            this.getTronStatus();
        }, 200);
    },


});


</script>


<style>
li.nav-item {
    background: white;
    border: 1px solid lightblue;
    padding: 0 0.5rem;
    border-radius: 50rem;
}


li.nav-item.active {
    background: #0d6efd;
    color: white !important;
}

li.nav-item.active a {
    color: white;
}

.nav-link {
    font-weight: 700 !important;
    color: #0d6efd99;
}
</style>