---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT6: Structs

Nombre de archivo propuesto: `NFT6_Structs.sol`

<details>

<summary>Requirements Structs</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a contract called `GarageManager`. Add the following in storage:

* A public mapping called `garage` to store a list of `Car`s (described below), indexed by address

Add the following types and functions.

#### Car Struct[​](https://docs.base.org/base-learn/docs/structs/structs-exercise#car-struct) <a href="#car-struct" id="car-struct"></a>

Implement a `struct` called `Car`. It should store the following properties:

* `make`
* `model`
* `color`
* `numberOfDoors`

#### Add Car Garage[​](https://docs.base.org/base-learn/docs/structs/structs-exercise#add-car-garage) <a href="#add-car-garage" id="add-car-garage"></a>

Add a function called `addCar` that adds a car to the user's collection in the `garage`. It should:

* Use `msg.sender` to determine the owner
* Accept arguments for make, model, color, and number of doors, and use those to create a new instance of `Car`
* Add that `Car` to the `garage` under the user's address

#### Get All Cars for the Calling User[​](https://docs.base.org/base-learn/docs/structs/structs-exercise#get-all-cars-for-the-calling-user) <a href="#get-all-cars-for-the-calling-user" id="get-all-cars-for-the-calling-user"></a>

Add a function called `getMyCars`. It should return an array with all of the cars owned by the calling user.

#### Get All Cars for Any User[​](https://docs.base.org/base-learn/docs/structs/structs-exercise#get-all-cars-for-any-user) <a href="#get-all-cars-for-any-user" id="get-all-cars-for-any-user"></a>

Add a function called `getUserCars`. It should return an array with all of the cars for any given `address`.

#### Update Car[​](https://docs.base.org/base-learn/docs/structs/structs-exercise#update-car) <a href="#update-car" id="update-car"></a>

Add a function called `updateCar`. It should accept a `uint` for the index of the car to be updated, and arguments for all of the `Car` types.

If the sender doesn't have a car at that index, it should revert with a custom `error` `BadCarIndex` and the index provided.

Otherwise, it should update that entry to the new properties.

#### Reset My Garage[​](https://docs.base.org/base-learn/docs/structs/structs-exercise#reset-my-garage) <a href="#reset-my-garage" id="reset-my-garage"></a>

Add a public function called `resetMyGarage`. It should delete the entry in `garage` for the sender.

</details>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title GarageManager
 * @dev Contract to manage a garage of cars for each user
 */
contract GarageManager {

    // Mapping to store the garage of cars for each user
    mapping(address => Car[]) private garages;

    // Struct to represent a car
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    // Custom error for handling invalid car index
    error BadCarIndex(uint256 index);

    /**
     * @dev Adds a new car to the caller's garage
     * @param _make The make of the car
     * @param _model The model of the car
     * @param _color The color of the car
     * @param _numberOfDoors The number of doors of the car
     */
    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint _numberOfDoors
    ) external {
        garages[msg.sender].push(Car(_make, _model, _color, _numberOfDoors));
    }

    /**
     * @dev Retrieves the caller's array of cars
     * @return An array of `Car` structs
     */
    function getMyCars() external view returns (Car[] memory) {
        return garages[msg.sender];
    }

    /**
     * @dev Retrieves a specific user's array of cars
     * @param _user The address of the user
     * @return An array of `Car` structs
     */
    function getUserCars(address _user) external view returns (Car[] memory) {
        return garages[_user];
    }

    /**
     * @dev Updates a specific car in the caller's garage
     * @param _index The index of the car in the garage array
     * @param _make The new make of the car
     * @param _model The new model of the car
     * @param _color The new color of the car
     * @param _numberOfDoors The new number of doors of the car
     */
    function updateCar(
        uint256 _index,
        string memory _make,
        string memory _model,
        string memory _color,
        uint _numberOfDoors
    ) external {
        if (_index >= garages[msg.sender].length) {
            revert BadCarIndex({index: _index});
        }
        garages[msg.sender][_index] = Car(_make, _model, _color, _numberOfDoors);
    }

    /**
     * @dev Deletes all cars in the caller's garage
     */
    function resetMyGarage() external {
        delete garages[msg.sender];
    }
}

```

