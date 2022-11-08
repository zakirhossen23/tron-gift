declare let window: any;

export default async function callContract() {
    const contract = { contract: null, signerAddress: null };
    try {

        contract.contract =  await window?.tronWeb.contract().at('TAuQGoaMNcYVYRAdoaY8V68uP1e4Y9c5pX');

        contract.signerAddress =  window?.tronWeb.defaultAddress.base58;

    } catch (error) {
        console.error(error);
    }
    return contract;
} 

