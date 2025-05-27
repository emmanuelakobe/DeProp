;; Define our own NFT trait
(define-trait property-nft-trait
  (
    (transfer (uint principal principal) (response bool uint))
    (get-owner (uint) (response principal uint))
    (mint (principal) (response uint uint))
  ))


;; Constants
(define-constant nft-contract .property-nft)
(define-constant admin tx-sender)

;; Maps
(define-map properties
  {property-id: uint}
  {
    name: (string-utf8 50),
    total-shares: uint,
    rent-per-share: uint,
    rent-collected: uint
  })

(define-map ownership
  {property-id: uint, user: principal}
  uint) ;; shares owned

;; Data Vars
(define-data-var property-counter uint u0)

;; Functions

(define-public (register-property (name (string-utf8 50)) (total-shares uint) (rent-per-share uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err u401))
    (let ((id (var-get property-counter)))
      (map-set properties {property-id: id}
        {
          name: name,
          total-shares: total-shares,
          rent-per-share: rent-per-share,
          rent-collected: u0
        })
      (var-set property-counter (+ id u1))
      (ok id))))

(define-public (buy-shares (property-id uint) (shares uint))
  (let ((prop (map-get? properties {property-id: property-id})))
    (match prop
      p
      (let (
        (price (* shares (get rent-per-share p)))
      )
        (try! (stx-transfer? price tx-sender admin))
        (let (
          (prev (default-to u0 (map-get? ownership {property-id: property-id, user: tx-sender})))
        )
          (map-set ownership {property-id: property-id, user: tx-sender} (+ prev shares))
          (ok true)))
      (err u404))))

(define-public (distribute-rent (property-id uint) (amount uint))
  (begin
    (asserts! (is-eq tx-sender admin) (err u401))
    (let (
      (prop (unwrap! (map-get? properties {property-id: property-id}) (err u404)))
    )
      (map-set properties {property-id: property-id}
        {
          name: (get name prop),
          total-shares: (get total-shares prop),
          rent-per-share: (get rent-per-share prop),
          rent-collected: (+ (get rent-collected prop) amount)
        })
      (ok true))))

(define-public (claim-rent (property-id uint))
  (let (
    (shares (default-to u0 (map-get? ownership {property-id: property-id, user: tx-sender})))
    (prop (unwrap! (map-get? properties {property-id: property-id}) (err u404)))
  )
    (let (
      (owed (* shares (get rent-per-share prop)))
    )
      (try! (stx-transfer? owed (as-contract tx-sender) tx-sender))
      (ok owed))))

;; Read-only
(define-read-only (get-property (property-id uint))
  (match (map-get? properties {property-id: property-id})
    p (ok p)
    (err u404)))

(define-read-only (get-shares (property-id uint) (user principal))
  (ok (default-to u0 (map-get? ownership {property-id: property-id, user: user}))))
