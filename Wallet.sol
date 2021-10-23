pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {

    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}

    // без оплаты комиссии за свой счет
    function TransactionWithoutCommission(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 64 + 2);
    }

    // с оплатой комисси за свой счет
    function TransactionWithCommission(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 0 + 1);
    }

    // все деньги и уничтожить кошелек
    function TransactioAndDestroyWallet(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
        dest.transfer(value, bounce, 128 + 32);
    }

    //default
    function sendTransaction(address dest, uint128 value, bool bounce) public pure checkOwnerAndAccept {
         // Runtime function that allows to make a transfer with arbitrary settings.
        dest.transfer(value, bounce, 0);
    }
}