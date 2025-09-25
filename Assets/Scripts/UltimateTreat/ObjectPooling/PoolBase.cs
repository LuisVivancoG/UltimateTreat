using System;
using UnityEngine.Pool;

public class PoolBase : ObjectPool<PooledAsset>
{
    public PoolBase(
            Func<PooledAsset> createFunc,
            Action<PooledAsset> actionOnGet = null,
            Action<PooledAsset> actionOnRelease = null,
            Action<PooledAsset> actionOnDestroy = null,
            bool collectionCheck = true,
            int defaultCapacity = 10,
            int maxSize = 100) : base(createFunc, actionOnGet, actionOnRelease, actionOnDestroy, collectionCheck, defaultCapacity, maxSize)
    { }
}
