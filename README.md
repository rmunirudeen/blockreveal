# BlockReveal Smart Contract

A Clarity smart contract that implements a commit-reveal scheme on Stacks blockchain. This pattern allows users to commit to a secret value without revealing it immediately, and then reveal it later at a specific block height.

## Features

- Commit a hashed secret with a specified unlock block height
- Reveal the secret once the unlock block height is reached
- View revealed secrets and commitment details
- Built-in validation and error handling

## Usage

### 1. Commit a Secret

First, hash your secret and commit it with an unlock block height:

```clarity
(contract-call? .blockreveal commit-secret 
    <hash>  ;; sha256 hash of your secret (buff 32)
    <unlock-at>  ;; future block height (uint)
)
```

### 2. Reveal the Secret

Once the unlock block height is reached, reveal your secret:

```clarity
(contract-call? .blockreveal reveal-secret
    <secret>  ;; your original secret (buff 100)
)
```

### 3. View a Revealed Secret

Query any revealed secret by principal:

```clarity
(contract-call? .blockreveal get-secret
    <user>  ;; principal
)
```

### 4. View Commitment Details

Query commitment details by principal:

```clarity
(contract-call? .blockreveal get-commitment
    <user>  ;; principal
)
```
