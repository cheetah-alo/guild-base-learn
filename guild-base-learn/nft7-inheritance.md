---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT7: Inheritance\*

Nombre de archivo propuesto: `NFT7_Inheritance.sol`

En este ejercicio se crearan varios contratos dentro del mismo archivo .sol que se relacionan entre si, es decir, uno hereda del otro. Para mantenerlo simple, solo sigue las indicaciones.

<details>

<summary>Requirements Inheritance</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

#### Employee[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#employee) <a href="#employee" id="employee"></a>

Create an `abstract` contract called `Employee`. It should have:

* A public variable storing `idNumber`
* A public variable storing `managerId`
* A constructor that accepts arguments for and sets both of these variables
* A `virtual` function called `getAnnualCost` that returns a `uint`

#### Salaried[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#salaried) <a href="#salaried" id="salaried"></a>

A contract called `Salaried`. It should:

* Inherit from `Employee`
* Have a public variable for `annualSalary`
* Implement an `override` function for `getAnnualCost` that returns `annualSalary`
* An appropriate constructor that performs any setup, including setting `annualSalary`

#### Hourly[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#hourly) <a href="#hourly" id="hourly"></a>

Implement a contract called `Hourly`. It should:

* Inherit from `Employee`
* Have a public variable storing `hourlyRate`
* Include any other necessary setup and implementation

tip

The annual cost of an hourly employee is their hourly rate \* 2080 hours.

#### Manager[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#manager) <a href="#manager" id="manager"></a>

Implement a contract called `Manager`. It should:

* Have a public array storing employee Ids
* Include a function called `addReport` that can add id numbers to that array
* Include a function called `resetReports` that can reset that array to empty

#### Salesperson[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#salesperson) <a href="#salesperson" id="salesperson"></a>

Implement a contract called `Salesperson` that inherits from `Hourly`.

#### Engineering Manager[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#engineering-manager) <a href="#engineering-manager" id="engineering-manager"></a>

Implement a contract called `EngineeringManager` that inherits from `Salaried` and `Manager`.

### <mark style="color:orange;">Deployments</mark>[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#deployments) <a href="#deployments" id="deployments"></a>

You'll have to do a more complicated set of deployments for this exercise.

Deploy your `Salesperson` and `EngineeringManager` contracts. You don't need to separately deploy the other contracts.

Use the following values:

#### <mark style="color:orange;">Salesperson</mark>[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#salesperson-1) <a href="#salesperson-1" id="salesperson-1"></a>

* Hourly rate is 20 dollars an hour
* Id number is 55555
* Manager Id number is 12345

#### <mark style="color:orange;">Manager</mark>[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#manager-1) <a href="#manager-1" id="manager-1"></a>

* Annual salary is 200,000
* Id number is 54321
* Manager Id is 11111

### Inheritance Submission[​](https://docs.base.org/base-learn/docs/inheritance/inheritance-exercise#inheritance-submission) <a href="#inheritance-submission" id="inheritance-submission"></a>

Copy the below contract and deploy it using the addresses of your `Salesperson` and `EngineeringManager` contracts.

```
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
```

</details>

Crear el archivo `NFT7_Inheritance.sol` y pegar le siguiente código.

```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

/**
 * @title Employee
 * @dev Abstract contract defining common properties and behavior for employees.
 */
abstract contract Employee {

    // Unique identifier for the employee
    uint public idNumber;

    // Identifier of the manager overseeing the employee
    uint public managerId;

    /**
     * @dev Constructor to initialize idNumber and managerId.
     * @param _idNumber The unique identifier for the employee.
     * @param _managerId The identifier of the manager overseeing the employee.
     */
    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    /**
     * @dev Abstract function to be implemented by derived contracts to get the annual cost of the employee.
     * @return The annual cost of the employee.
     */
    function getAnnualCost() public virtual view returns (uint);
}

/**
 * @title Salaried
 * @dev Contract representing employees who are paid an annual salary.
 */
contract Salaried is Employee {

    // The annual salary of the employee
    uint public annualSalary;

    /**
     * @dev Constructor to initialize the Salaried contract.
     * @param _idNumber The unique identifier for the employee.
     * @param _managerId The identifier of the manager overseeing the employee.
     * @param _annualSalary The annual salary of the employee.
     */
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    /**
     * @dev Overrides the getAnnualCost function to return the annual salary of the employee.
     * @return The annual salary of the employee.
     */
    function getAnnualCost() public override view returns (uint) {
        return annualSalary;
    }
}

/**
 * @title Hourly
 * @dev Contract representing employees who are paid an hourly rate.
 */
contract Hourly is Employee {

    // The hourly rate of the employee
    uint public hourlyRate;

    /**
     * @dev Constructor to initialize the Hourly contract.
     * @param _idNumber The unique identifier for the employee.
     * @param _managerId The identifier of the manager overseeing the employee.
     * @param _hourlyRate The hourly rate of the employee.
     */
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    /**
     * @dev Overrides the getAnnualCost function to calculate the annual cost based on the hourly rate.
     * Assuming a full-time workload of 2080 hours per year.
     * @return The annual cost of the employee.
     */
    function getAnnualCost() public override view returns (uint) {
        return hourlyRate * 2080;
    }
}

/**
 * @title Manager
 * @dev Contract managing a list of employee IDs.
 */
contract Manager {

    // List of employee IDs
    uint[] public employeeIds;

    /**
     * @dev Function to add a new employee ID to the list.
     * @param _reportId The ID of the employee to be added.
     */
    function addReport(uint _reportId) public {
        employeeIds.push(_reportId);
    }

    /**
     * @dev Function to reset the list of employee IDs.
     */
    function resetReports() public {
        delete employeeIds;
    }
}

/**
 * @title Salesperson
 * @dev Contract representing salespeople who are paid hourly.
 */
contract Salesperson is Hourly {

    /**
     * @dev Constructor to initialize the Salesperson contract.
     * @param _idNumber The unique identifier for the employee.
     * @param _managerId The identifier of the manager overseeing the employee.
     * @param _hourlyRate The hourly rate of the employee.
     */
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Hourly(_idNumber, _managerId, _hourlyRate) {
        // Ensure the constructor fully initializes all parent properties.
    }
}

/**
 * @title EngineeringManager
 * @dev Contract representing engineering managers who are paid an annual salary and have managerial responsibilities.
 */
contract EngineeringManager is Salaried, Manager {

    /**
     * @dev Constructor to initialize the EngineeringManager contract.
     * @param _idNumber The unique identifier for the employee.
     * @param _managerId The identifier of the manager overseeing the employee.
     * @param _annualSalary The annual salary of the employee.
     */
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) Salaried(_idNumber, _managerId, _annualSalary) {
        // Ensure the constructor fully initializes all parent properties.
    }
}

/**
 * @title InheritanceSubmission
 * @dev Contract for deploying instances of Salesperson and EngineeringManager.
 */
contract InheritanceSubmission {

    // Address of the deployed Salesperson instance
    address public salesPerson;

    // Address of the deployed EngineeringManager instance
    address public engineeringManager;

    /**
     * @dev Constructor to initialize the InheritanceSubmission contract.
     * @param _salesPerson Address of the deployed Salesperson instance.
     * @param _engineeringManager Address of the deployed EngineeringManager instance.
     */
    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
```



Luego de crear el archivo y hacer el compilado, vamos al Deploy. Alli vmeos que tenemos un desplegable, lo abrimos para visualizar todos los contratos dentro del "contrato madre -> `NFT7_Inheritance.sol`" desplegado.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 7.58.35 PM.png" alt="" width="238"><figcaption></figcaption></figure>

Lo que tenemos que hacer es dar el input a 3 contratos para poder desplegarlos por separado. Sigue con atención los siguientes pasos

1. Seleccionamos <mark style="color:orange;">**Salesperson**</mark>. Tomamos en cuenta los inputs dados en el requerimiento de la creación del contrato.&#x20;

<details>

<summary>Salesperson​</summary>

* Hourly rate is 20 dollars an hour
* Id number is 55555
* Manager Id number is 12345

</details>

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 7.44.56 PM.png" alt="" width="260"><figcaption></figcaption></figure>

2. Confirmamos la transacción.

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 7.46.48 PM.png" alt=""><figcaption></figcaption></figure>

3. Observamos que en el terminal aparacera una nueva transaccion con Salesperson.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 7.47.10 PM.png" alt=""><figcaption></figcaption></figure>

4. Repetimos los pasos con <mark style="color:orange;">**EngineeringManager**</mark>.

<details>

<summary>EngineeringManager</summary>

* Annual salary is 200000
* Id number is 54321
* Manager Id is 11111

</details>

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 8.03.30 PM.png" alt="" width="235"><figcaption></figcaption></figure>

5. Ahora para <mark style="color:orange;">**InheritanceSubmission,**</mark> copiamos las direcciones de los contratos que acabamos de desplegar como se muestra en la figura.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2024-12-28 at 7.52.30 PM.png" alt=""><figcaption></figcaption></figure>

<mark style="color:purple;">**Este último contrato que se crea es la dirección que copiaremos y la pegaremos en el guilt.**</mark>&#x20;
