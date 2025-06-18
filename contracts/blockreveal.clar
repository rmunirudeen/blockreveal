(define-map commitments
  principal ;; Who committed
  {
    hash: (buff 32),
    unlock-block: uint,
    revealed: bool
  })

(define-map secrets
  principal
  (buff 100))

(define-constant ERR_ALREADY_COMMITTED u100)
(define-constant ERR_NO_COMMIT u101)
(define-constant ERR_TOO_EARLY u102)
(define-constant ERR_HASH_MISMATCH u103)
(define-constant ERR_ALREADY_REVEALED u104)

;; 1. Commit a secret hash and unlock block
(define-public (commit-secret (hash (buff 32)) (unlock-at uint))
  (begin
    (asserts! (is-none (map-get? commitments tx-sender)) (err ERR_ALREADY_COMMITTED))
    (map-set commitments tx-sender {
      hash: hash,
      unlock-block: unlock-at,
      revealed: false
    })
    (ok true)
  )
)

;; 2. Reveal the secret if the block height and hash match
(define-public (reveal-secret (secret (buff 100)))
  (let (
    (commitment (unwrap! (map-get? commitments tx-sender) (err ERR_NO_COMMIT)))
    (hashed (sha256 secret))
  )
    (begin
      (asserts! (>= burn-block-height (get unlock-block commitment)) (err ERR_TOO_EARLY))
      (asserts! (is-eq (get hash commitment) hashed) (err ERR_HASH_MISMATCH))
      (asserts! (not (get revealed commitment)) (err ERR_ALREADY_REVEALED))
      (map-set secrets tx-sender secret)
      (map-set commitments tx-sender (merge commitment { revealed: true }))
      (ok true)
    )
  )
)

;; 3. View someone's revealed secret (if revealed)
(define-read-only (get-secret (user principal))
  (map-get? secrets user)
)

;; 4. View commitment details
(define-read-only (get-commitment (user principal))
  (map-get? commitments user)
)

;; Get the current block height
(define-read-only (get-block-height)
  burn-block-height)
