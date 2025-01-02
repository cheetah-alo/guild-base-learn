// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {
    function adder(uint256 _a, uint256 _b) external pure returns (uint256 sum, bool error) {
        unchecked {
            if (_a + _b < _a) {
                return (0, true); // Overflow occurred
            }
        }
        return (_a + _b, false);
    }

    function subtractor(uint256 _a, uint256 _b) external pure returns (uint256 difference, bool error) {
        if (_b > _a) {
            return (0, true); // Underflow occurred
        }
        return (_a - _b, false);
    }
}
