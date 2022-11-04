<template>
  <div class="mint-page p-4">
    <h3>Mint a Gift Card</h3>
    <div class="d-flex gap-5 justify-content-center m-3 m-lg-5 show-grid">
      <div class="d-flex">
        <div class="position-relative" style="width:400px;height:220px;">
          <div class="d-flex h-100 justify-content-sm-around w-100"
            style="background-color:rgb(33, 37, 41);color:white;border-radius:10px;">
            <div class="d-block position-relative" style="width:238px;padding:13px 0px 0px 13px;">
              <div class="d-flex flex-column h-75 justify-content-center"><small class=""
                  style="font-family:Arial;">(Write your message)</small></div>
              <div class="align-items-center d-flex flex-column position-absolute" style="bottom:9px;width:225px;">
                <small class="fw-bold text-center text-muted"
                  style="bottom:20px;padding:0px;font-size:0.8rem;line-height:1.57;letter-spacing:0.00714em;">Write your
                  name</small><small class="fw-bolder lh-base m-0 text-center"
                  style="bottom:20px;font-family:calibri;letter-spacing:0.00938em;color:rgb(158, 158, 158);text-align:center;font-size:0.5rem;">0x168e007d9f5a794794e40035c5214963cb16bfb7</small>
              </div>
            </div>
            <div class="d-block position-absolute" style="/* width:238px; */padding:13px 0px 0px 13px;left: 0rem;">
              <h4>TRX 5</h4>
            </div>
            <div class="align-items-center d-flex flex-column justify-content-center" style="width: 183px;"><img
                src="https://th.bing.com/th/id/R.5de3ee8846b54b5bfefdb3f503693fec?rik=51mB3RmbhSK8Xw&amp;pid=ImgRaw&amp;r=0"
                class="" style="width: 160px;height:160px;font-family:Arial;"></div>
          </div>
        </div>
      </div>
      <form style="min-width: 25rem;">
        <div class="col-auto">
          <input type="text" class="form-control " placeholder="Recipient Wallet" style="height: 3rem;" />
          <div class="form-text text-md-start">This is the wallet of the person who you want to send this <p>gift card
              to</p>
          </div>
        </div>
        <div class="input-group mb-3">
          <span class="input-group-text">TRX</span>
          <input style="height: 3rem;" placeholder="Amount" class="form-control " type="text">
        </div>
        <div class="col-auto mb-3">
          <textarea class="form-control" rows="3" placeholder="Message" style="height: 73px;"></textarea>
        </div>
        <div class="col-auto mb-3">
          <input type="text" class="form-control " placeholder="Your Name" style="height: 3rem;">
        </div><button type="submit" class="btn btn-primary rounded-5 w-100">Mint your Gift</button>
      </form>
    </div>
  </div>
</template>
