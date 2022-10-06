//! Taken from https://github.com/MystenLabs/sui/pull/4887/files#diff-96b0dc07cabd79292618c993cd473c43ca81cd2f742266014967cdea1a7c6186
//! and modified.

module syrup::safe {
    use sui::object::{ID, UID};
    use sui::transfer::transfer_to_object;
    use syrup::collection::{Trade};

    /// A shared object for storing NFT's of type `T`, owned by the holder of a unique `OwnerCap`.
    /// Permissions to allow others to list NFT's can be granted via TransferCap's and BorrowCap's
    struct Safe<phantom T> has key {
        id: UID,
        owner: address,
        // ... contains the fields from MR
    }

    /// A unique capability held by the owner of a particular `Safe`.
    /// The holder can issue and revoke `TransferCap`'s and `BorrowCap`'s.
    /// Can be used an arbitrary number of times
    struct OwnerCap has key, store {
        id: UID,
        /// The ID of the safe that this capability grants permissions to
        safe_id: ID,
    }

    /// Gives the holder permission to transfer the nft with id `nft_id` out of
    /// the safe with id `safe_id`. Can only be used once.
    struct TransferCap has key, store {
        id: UID,
        safe_id: ID,
        nft_id: ID,
        // only one transfer cap for this nft can exist if this is true
        is_exlusive: bool,
    }

    /// Produce a `TransferCap` for the NFT with `id` in `safe`.
    /// This `TransferCap` can be (e.g.) used to list the NFT on a marketplace.
    public fun sell_nft<T>(_owner_cap: &OwnerCap, _id: ID, _safe: &mut T): TransferCap {
        abort(0)
    }

    public fun trade_nft<Wness, T, FT>(
        _cap: TransferCap,
        trade: Trade<Wness>,
        safe: &mut Safe<T>,
    ): T {
        transfer_to_object(trade, safe);

        abort(0)
    }

    public fun safe_owner<Col>(safe: &Safe<Col>): address {
        safe.owner
    }

    public fun transfer_cap_safe_id(cap: &TransferCap): ID {
        cap.safe_id
    }

    public fun transfer_cap_nft_id(cap: &TransferCap): ID {
        cap.nft_id
    }

    public fun transfer_cap_is_exclusive(cap: &TransferCap): bool {
        cap.is_exlusive
    }
}
