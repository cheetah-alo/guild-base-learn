---
cover: ../.gitbook/assets/Screenshot 2024-12-28 at 10.05.23 PM.png
coverY: 0
---

# NFT1: Deploying to a testnet

<details>

<summary>Requirements Basic Math</summary>

**Contract**[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#contract)

Create a contract called `BasicMath`. It should not inherit from any other contracts and does not need a constructor. It should have the following two functions:

#### Adder[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#adder) <a href="#adder" id="adder"></a>

A function called `adder`. It must:

* Accept two `uint` arguments, called `_a` and `_b`
* Return a `uint` `sum` and a `bool` `error`
* If `_a` + `_b` does not overflow, it should return the `sum` and an `error` of `false`
* If `_a` + `_b` overflows, it should return `0` as the `sum`, and an `error` of `true`

#### Subtractor[​](https://docs.base.org/base-learn/docs/contracts-and-basic-functions/basic-functions-exercise#subtractor) <a href="#subtractor" id="subtractor"></a>

A function called `subtractor`. It must:

* Accept two `uint` arguments, called `_a` and `_b`
* Return a `uint` `difference` and a `bool` `error`
* If `_a` - `_b` does not underflow, it should return the `difference` and an `error` of `false`
* If `_a` - `_b` underflows, it should return `0` as the `difference`, and an `error` of `true`

</details>

En Remix en la carpeta contract, creamos un nuevo archivo llamado `NFT1_BasicMath.sol`

<figure><img src="../.gitbook/assets/Screenshot 2024-12-27 at 6.27.13 PM.png" alt=""><figcaption></figcaption></figure>

Luego, una vez sobre el archivo copiamos el siguiente código:

```solidity

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


```

<figure><img src="../.gitbook/assets/Screenshot 2024-12-27 at 6.29.37 PM.png" alt=""><figcaption></figcaption></figure>

Compilamos, Hacemos el Deploy y copiamos la dirección como se mostro en la sección de arriba.&#x20;

<mark style="color:red;">**ESTOS PASOS LOS REPETIMOS PARA LOS 13 NFTS**</mark>\
\
Nos vamos a la pagina [https://docs.base.org/base-learn/progress/](https://docs.base.org/base-learn/progress/), hacemos click sobre el primer NFT "Deploying to a Testnet". Conectamos la Wallet, verificamos que este en la red de Base Sepolia y pegamos la direccion del smart contract tomada desde REMIX.&#x20;

<figure><img src="../.gitbook/assets/Screenshot 2024-12-27 at 6.33.54 PM.png" alt=""><figcaption></figcaption></figure>

Una vez pegada la direccion, le damos en el paso <mark style="color:orange;">**2**</mark> a **Submit**, y nos saldra una ventana de Metamask para "<mark style="color:blue;">**Confirmar**</mark>" la transacción.&#x20;

Luego apareceran los checks del cumplimiento con lo requerido en el smart contract.\


<figure><img src="../.gitbook/assets/image (1).png" alt=""><figcaption></figcaption></figure>

Una vez confirmada, saldra el NFT activo en la pagina de Base Learn.&#x20;

