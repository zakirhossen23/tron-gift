// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract TronGift {

    /// GiftCard contains all the metadata stored within an NFT.
    struct gift_card_struct { 
        /// The ID of the Gift ID.
        uint256 gift_id;
        /// The one who sent this gift card.
        string signedBy;
        /// To address 
        string owner_address;
        /// Message on the gift card.
        string message;
        ///From name
        string name;
        /// The amount that is wrapped within this gift card.
        uint256 amount;
        /// Whether the amount in the gift is unwrapped.
        bool isUnwrapped;
        /// Time at which this gift card was minted.
        uint256 timestamp;
    }
    
	uint256 private _GiftIds;
	 /// The map of all the gift cards attached.
	mapping(uint256 => gift_card_struct) public _giftMap;  
	
	/// List of gifts sent by an address.
    mapping(address => uint256[]) private _sentGifts;

	address public owner;

    function mintGift(
		string memory signedBy,
		string memory recipient_address,
		string memory message,
		string memory name
	) public payable  {	
	      // Take a cut from the minting.
        uint256 mintFees = _calculateMintFees(msg.value);
        uint256 giftValue = msg.value - mintFees;
	    
	     // Store the metadata of the NFT in the map.
	    _giftMap[_GiftIds] = gift_card_struct({
	        gift_id: _GiftIds,
	        signedBy: signedBy,
	        owner_address: recipient_address,
	        message: message,
	        name: name,
	        amount: giftValue,
	        isUnwrapped: false,
	        timestamp: block.timestamp
	    });
		_sentGifts[msg.sender].push(_GiftIds);
	    _GiftIds++;
	}


    //Gets all the gift owned by address
    function getAllGiftCardOfOwner(string memory owner_address)
		public 
		view
		returns (gift_card_struct[] memory)
	{

        ///Getting a temporary total gifts found count
		uint256 _TemporarySearch = 0;
		for (uint256 i = 0; i < _GiftIds; i++) {
			if (
				keccak256(bytes(_giftMap[i].owner_address)) ==
				keccak256(bytes(owner_address))
			) {
				_TemporarySearch++;
			}
		}
		
		///Intializing Gift Cards Array with that temporary counted number
		gift_card_struct[] memory _SearchedStoreGiftCards = new gift_card_struct[](_TemporarySearch);
        ///For indexing into searched Gift Cards
		uint256 _GiftSearchIds = 0;

        ///Itering into Gift Map and storing found Gifts 
		for (uint256 i = 0; i < _GiftIds; i++) {
			if (
				keccak256(bytes(_giftMap[i].owner_address)) ==
				keccak256(bytes(owner_address))
			) {
				_SearchedStoreGiftCards[_GiftSearchIds] = _giftMap[i];
				_GiftSearchIds++;
			}
		}


        ///Returning All the Found Gift cards
		return _SearchedStoreGiftCards;
	}


    //Gets all the gift sent by address
    function getAllGiftCardBySentAddress(string memory senderAddress)
		public 
		view
		returns (gift_card_struct[] memory)
	{

        ///Getting a temporary total gifts found count
		uint256 _TemporarySearch = 0;
		for (uint256 i = 0; i < _GiftIds; i++) {
			if (
				keccak256(bytes(_giftMap[i].signedBy)) ==
				keccak256(bytes(senderAddress))
			) {
				_TemporarySearch++;
			}
		}
		
		///Intializing Gift Cards Array with that temporary counted number
		gift_card_struct[] memory _SearchedStoreGiftCards = new gift_card_struct[](_TemporarySearch);
        ///For indexing into searched Gift Cards
		uint256 _GiftSearchIds = 0;

        ///Itering into Gift Map and storing found Gifts 
		for (uint256 i = 0; i < _GiftIds; i++) {
			if (
				keccak256(bytes(_giftMap[i].signedBy)) ==
				keccak256(bytes(senderAddress))
			) {
				_SearchedStoreGiftCards[_GiftSearchIds] = _giftMap[i];
				_GiftSearchIds++;
			}
		}


        ///Returning All the Found Gift cards
		return _SearchedStoreGiftCards;
	}


    /// Unwraps the gift and sends the amount stored in the gift card to the owner.
    function _unwrapGiftCardAndDisburse(gift_card_struct memory gift, address owner_address)
        private
    {
        uint256 giftAmount = gift.amount;
        require(
            gift.isUnwrapped == false,
            "TronGiftCard: cannot unwrap already unwrapped gift card"
        );
        // The gift is unwrapped now. Do not allow the same gift to redeem the amount again.
        _giftMap[gift.gift_id].isUnwrapped = true;
        _giftMap[gift.gift_id].amount = 0;

        address payable sender = payable(owner_address);
        // Send the gift amount to the caller.
        (bool sent, ) = sender.call{value: giftAmount}("");
        require(sent, "TronGiftCard: failed to unwrap gift card");
    }



    /// Unwraps the amount stored in the gift card and withdraws it in the owner's wallet.
    function unwrapGiftCard(uint256 giftId) public {
        /// Getting Gift and Unwarping
        gift_card_struct memory gift = _giftMap[giftId];
        _unwrapGiftCardAndDisburse(gift, msg.sender);
    }



    /// Calculates the minting fees. This is what we earn for the service we provide.
    /// The fee is 5% of the gift card value capped at 1 TRX.
    function _calculateMintFees(uint256 value) private pure returns (uint256) {
        // Fee is calculated by using 5% of gift value (x). And the amount (y) that is sent
        // to the contract is x + 5% of x.
        uint256 fee = value * 5 / 105;

        uint256 oneTRX = 1_000_000;
        if (fee > oneTRX) {
            fee = oneTRX;
        }

        return fee;
    }

}

 
