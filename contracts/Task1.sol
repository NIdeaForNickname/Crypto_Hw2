pragma solidity ^0.8.0;

library ArrayLibrary {

    function find(uint256[] storage arr, uint256 val) internal view returns (int256) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == val) return int256(i);
        }
        return -1;
    }

    function remove(uint256[] storage arr, uint256 index) internal {
        require(index < arr.length, "out of bounds");
        for (uint256 i = index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    function sort(uint256[] storage arr) internal {
        uint256 l = arr.length;
        for (uint256 i = 0; i < l; i++) {
            for (uint256 j = i + 1; j < l; j++) {
                if (arr[i] > arr[j]) {
                    uint256 temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
    }
}

contract ArrayUtils {
    using ArrayLibrary for uint256[];
    uint256[] public data;

    function addElement(uint256 _val) public { data.push(_val); }

    function processArray(uint256 _valToRemove) public {
        data.sort(); 
        int256 index = data.find(_valToRemove);
        if (index >= 0) {
            data.remove(uint256(index));
        }
    }

    function getData() public view returns (uint256[] memory) { return data; }
}