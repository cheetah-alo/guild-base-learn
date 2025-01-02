---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT3: Storage\*

Nombre de archivo propuesto: `NFT3_Storage.sol`

<details>

<summary>Requirements Storage</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a single contract called `EmployeeStorage`. It should not inherit from any other contracts. It should have the following functions:

#### State Variables[​](https://docs.base.org/base-learn/docs/storage/storage-exercise#state-variables) <a href="#state-variables" id="state-variables"></a>

The contract should have the following state variables, optimized to minimize storage:

* A private variable `shares` storing the employee's number of shares owned
  * Employees with more than 5,000 shares count as directors and are stored in another contract
* Public variable `name` which stores the employee's name
* A private variable `salary` storing the employee's salary
  * Salaries range from 0 to 1,000,000 dollars
* A public variable `idNumber` storing the employee's ID number
  * Employee numbers are not sequential, so this field should allow any number up to 2^256-1

#### Constructor[​](https://docs.base.org/base-learn/docs/storage/storage-exercise#constructor) <a href="#constructor" id="constructor"></a>

<mark style="color:orange;">**When deploying the contract, utilize the**</mark><mark style="color:orange;">**&#x20;**</mark><mark style="color:orange;">**`constructor`**</mark><mark style="color:orange;">**&#x20;**</mark><mark style="color:orange;">**to set:**</mark>

* `shares`
* `name`
* `salary`
* `idNumber`

<mark style="color:orange;">**For the purposes of the test, you must deploy the contract with the following values:**</mark>

* `shares` - 1000
* `name` - Pat
* `salary` - 50000
* `idNumber` - 112358132134

#### View Salary and View Shares[​](https://docs.base.org/base-learn/docs/storage/storage-exercise#view-salary-and-view-shares) <a href="#view-salary-and-view-shares" id="view-salary-and-view-shares"></a>

danger

In the world of blockchain, nothing is ever secret!\* `private` variables prevent other contracts from reading the value. You should use them as a part of clean programming practices, but marking a variable as private **does&#x20;**_**not**_**&#x20;hide the value**. All data is trivially available to anyone who knows how to fetch data from the chain.

\*You can make clever use of encryption though!

Write a function called `viewSalary` that returns the value in `salary`.

Write a function called `viewShares` that returns the value in `shares`.

#### Grant Shares[​](https://docs.base.org/base-learn/docs/storage/storage-exercise#grant-shares) <a href="#grant-shares" id="grant-shares"></a>

Add a public function called `grantShares` that increases the number of shares allocated to an employee by `_newShares`. It should:

* Add the provided number of shares to the `shares`
  * If this would result in more than 5000 shares, revert with a custom error called `TooManyShares` that returns the number of shares the employee would have with the new amount added
  * If the number of `_newShares` is greater than 5000, revert with a string message, "Too many shares"

</details>

NOTA: Para desplegar el contrato hay que hacer lo siguiente:

1. Al tratar de dar click en desplegar, lo encontramos desactivado. Para poder activarlo, hay que abrir el desplegable que nos aparece. Paso <mark style="color:orange;">**1, como se muestra en la figura.**</mark>

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 5.28.23 PM.png" alt="" width="254"><figcaption></figcaption></figure>

2. Introducir los siguientes datos en el paso <mark style="color:orange;">**2**</mark>, estos son indicados en los requerimientos del contrato (Requirements Storage, al desplegarlo lo ubicaras por las lineas en naranja.). Una vez añadidos, hacer click en <mark style="color:orange;">**transact**</mark>, paso <mark style="color:orange;">**3**</mark>.&#x20;

`shares` - 1000

`name` - Pat

`salary` - 50000

`idNumber` - 112358132134

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 5.33.41 PM.png" alt="" width="242"><figcaption></figcaption></figure>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EmployeeStorage {
    // Declare private state variables to store employee data
    // Number of shares owned by the employee (private to contract)
    uint16 private shares; 
    // Monthly salary of the employee (private to contract)
    uint32 private salary; 
    // Unique identification number of the employee (publicly accessible)
    uint256 public idNumber; 
    // Name of the employee (publicly accessible)
    string public name; 

    // Constructor to initialize employee data when contract is deployed
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint _idNumber) {
        shares = _shares; 
        name = _name; 
        salary = _salary; 
        idNumber = _idNumber; 
    }

    // View function to retrieve the number of shares owned by the employee
    function viewShares() public view returns (uint16) {
        return shares;
    }
    
    // View function to retrieve the monthly salary of the employee
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    // Custom error declaration
    error TooManyShares(uint16 _shares);
    
    // Function to grant additional shares to the employee
    function grantShares(uint16 _newShares) public {
        // Check if the requested shares exceed the limit
        if (_newShares > 5000) {
            revert("Too many shares"); // Revert with error message
        } else if (shares + _newShares > 5000) {
            revert TooManyShares(shares + _newShares); // Revert with custom error message
        }
        shares += _newShares; // Grant the new shares
    }

    // Function used for testing packing of storage variables (not relevant to main functionality)
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload (_slot)
        }
    }

    // Function to reset shares for debugging purposes (not relevant to main functionality)
    function debugResetShares() public {
        shares = 1000; // Reset shares to 1000
    }
}
```

####
