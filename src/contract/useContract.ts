declare let window: any;

export default async function callContract() {
    const contract = { contract: null, signerAddress: null };
    try {

        contract.contract =  await window?.tronWeb.contract().at('TYwY78jsnnH1csRDzUfw8MxGgXffoe4uG2');

        contract.signerAddress =  window?.tronWeb.defaultAddress.base58;

    } catch (error) {
        console.error(error);
    }
    return contract;
} 

