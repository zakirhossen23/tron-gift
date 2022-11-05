declare let window: any;

export default async function callContract() {
    const contract = { contract: null, signerAddress: null };
    try {

        contract.contract =  await window?.tronWeb.contract().at('TNP2EJTE8wxw4gLYWuSNQZvU3Kos7jzZLz');

        contract.signerAddress =  window?.tronWeb.defaultAddress.base58;

    } catch (error) {
        console.error(error);
    }
    return contract;
} 

