pragma solidity ^0.8.0;

contract Grandma {
    struct child {
        uint256 birthTimestamp;
        bool withdrawn;
    }

    mapping(address => child) public grandchildren;
    uint256 public giftAmount;
    address public grandma;

    constructor(address[] memory _addresses, uint256[] memory _birthdays) payable {
        require(_addresses.length == _birthdays.length, "Mismatch data");
        grandma = msg.sender;
        giftAmount = msg.value / _addresses.length;

        for (uint i = 0; i < _addresses.length; i++) {
            grandchildren[_addresses[i]] = child(_birthdays[i], false);
        }
    }

    function claimGift() public {
        child storage kid = grandchildren[msg.sender];
        require(kid.birthTimestamp > 0, "not a grandchild");
        require(block.timestamp >= kid.birthTimestamp, "early");
        require(!kid.withdrawn, "already taken");

        kid.withdrawn = true;
        payable(msg.sender).transfer(giftAmount);
    }
}