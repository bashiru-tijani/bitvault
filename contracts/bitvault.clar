;; BitVault - Decentralized Bitcoin Treasury Management Protocol

;; Summary:
;; BitVault is a sophisticated decentralized autonomous treasury built on Stacks,
;; enabling Bitcoin-backed fund management through democratic governance and
;; time-locked asset security mechanisms.

;; Description:
;; BitVault revolutionizes decentralized fund management by leveraging Bitcoin's
;; security through Stacks Layer 2 infrastructure. This protocol enables users
;; to participate in collective treasury management where STX deposits are secured
;; through time-lock mechanisms and governance decisions are made through weighted
;; voting based on stake contributions. The system implements robust security
;; measures including proposal validation, execution timeframes, and anti-manipulation
;; safeguards to ensure democratic and secure fund operations. BitVault bridges
;; traditional treasury management with Bitcoin's immutable security model.

;; CONSTANTS AND ERROR CODES

(define-constant contract-owner tx-sender)

;; Error Definitions
(define-constant err-owner-only (err u100))
(define-constant err-not-initialized (err u101))
(define-constant err-already-initialized (err u102))
(define-constant err-insufficient-balance (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-unauthorized (err u105))
(define-constant err-proposal-not-found (err u106))
(define-constant err-proposal-expired (err u107))
(define-constant err-already-voted (err u108))
(define-constant err-below-minimum (err u109))
(define-constant err-locked-period (err u110))
(define-constant err-transfer-failed (err u111))
(define-constant err-invalid-duration (err u112))
(define-constant err-zero-amount (err u113))
(define-constant err-invalid-target (err u114))
(define-constant err-invalid-description (err u115))
(define-constant err-invalid-proposal-id (err u116))
(define-constant err-invalid-vote (err u117))

;; Protocol Parameters
(define-constant minimum-duration u144) ;; Minimum 1 day (10min blocks)
(define-constant maximum-duration u20160) ;; Maximum 14 days

;; STATE VARIABLES

(define-data-var total-supply uint u0)
(define-data-var minimum-deposit uint u1000000) ;; 1 STX minimum in microSTX
(define-data-var lock-period uint u1440) ;; ~10 days lock period
(define-data-var initialized bool false)
(define-data-var last-rebalance uint u0)
(define-data-var proposal-count uint u0)

;; DATA STRUCTURES

;; User balance tracking
(define-map balances
  principal
  uint
)

;; Deposit information with time-lock mechanism
(define-map deposits
  principal
  {
    amount: uint,
    lock-until: uint,
    last-reward-block: uint,
  }
)

;; Governance proposal structure
(define-map proposals
  uint
  {
    proposer: principal,
    description: (string-ascii 256),
    amount: uint,
    target: principal,
    expires-at: uint,
    executed: bool,
    yes-votes: uint,
    no-votes: uint,
  }
)

;; Vote tracking to prevent double voting
(define-map votes
  {
    proposal-id: uint,
    voter: principal,
  }
  bool
)