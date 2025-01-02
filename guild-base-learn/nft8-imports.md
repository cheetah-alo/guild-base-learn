---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT8: Imports\*

<details>

<summary>Requirements Imports</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a contract called `ImportsExercise`. It should `import` a copy of `SillyStringUtils`

```
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

library SillyStringUtils {

    struct Haiku {
        string line1;
        string line2;
        string line3;
    }

    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}
```

Add a public instance of `Haiku` called `haiku`.

Add the following two functions.

#### Save Haiku[​](https://docs.base.org/base-learn/docs/imports/imports-exercise#save-haiku) <a href="#save-haiku" id="save-haiku"></a>

`saveHaiku` should accept three strings and save them as the lines of `haiku`.

#### Get Haiku[​](https://docs.base.org/base-learn/docs/imports/imports-exercise#get-haiku) <a href="#get-haiku" id="get-haiku"></a>

`getHaiku` should return the haiku as a `Haiku` type.

info

Remember, the compiler will automatically create a getter for `public` `struct`s, but these return each member individually. Create your own getters to return the type.

#### Shruggie Haiku[​](https://docs.base.org/base-learn/docs/imports/imports-exercise#shruggie-haiku) <a href="#shruggie-haiku" id="shruggie-haiku"></a>

`shruggieHaiku` should use the library to add 🤷 to the end of `line3`. It must **not** modify the original haiku. It should return the modified `Haiku`.

***

### Submit your Contract and Earn an NFT Badge! (BETA)[​](https://docs.base.org/base-learn/docs/imports/imports-exercise#submit-your-contract-and-earn-an-nft-badge-beta) <a href="#submit-your-contract-and-earn-an-nft-badge-beta" id="submit-your-contract-and-earn-an-nft-badge-beta"></a>

caution

**Contract Verification Best Practices**[**​**](https://docs.base.org/base-learn/docs/imports/imports-exercise#contract-verification-best-practices)

To simplify the verification of your contract on a blockchain explorer like BaseScan.org, consider these two common strategies:

1. **Flattening**: This method involves combining your main contract and all of its imported dependencies into a single file. This makes it easier for explorers to verify the code since they only have to process one file.
2. **Modular Deployment**: Alternatively, you can deploy each imported contract separately and then reference them in your main contract via their deployed addresses. This approach maintains the modularity and readability of your code. Each contract is deployed and verified independently, which can facilitate easier updates and reusability.
3. **Use Desktop Tools**: Forge and Hardhat both have tools to write scripts that both deploy and verify your contracts.

</details>

Aquí hay que crear dos archivos. El del contrato principal, y segundo del que se hereda en el principal. Cremos dos archivos y desplegamos ambos, pero primero este de SillyStringutils.sol&#x20;

File: `SillyStringUtils.sol`

```solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

library SillyStringUtils {

    struct Haiku {
        string line1;
        string line2;
        string line3;
    }

    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}
```

File: `NFT8_Imports.sol`

```solidity
// SPDX-License-Identifier: MIT

// Importing the SillyStringUtils library
import "./SillyStringUtils.sol";

pragma solidity ^0.8.17;

/**
 * @title ImportsExercise
 * @dev Contract to manage and manipulate Haiku using SillyStringUtils library.
 */
contract ImportsExercise {

    // Using the SillyStringUtils library for string manipulation
    using SillyStringUtils for string;

    // Declaring a public variable to store a Haiku
    SillyStringUtils.Haiku public haiku;

    /**
     * @dev Function to save a Haiku.
     * @param _line1 The first line of the Haiku.
     * @param _line2 The second line of the Haiku.
     * @param _line3 The third line of the Haiku.
     */
    function saveHaiku(string memory _line1, string memory _line2, string memory _line3) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    /**
     * @dev Function to retrieve the saved Haiku.
     * @return The Haiku as a SillyStringUtils.Haiku type.
     */
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    /**
     * @dev Function to append a shrugging emoji to the third line of the Haiku.
     * @return A new Haiku with the modified third line.
     */
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory newHaiku = haiku;
        newHaiku.line3 = newHaiku.line3.shruggie();
        return newHaiku;
    }
}
```

####
