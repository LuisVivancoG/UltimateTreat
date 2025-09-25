using System;
using UnityEngine;
using UnityEngine.Pool;

public class ItemsPool : ObjectPool<ItemBase>
{
    public ItemsPool(
            Func<ItemBase> createFunc,
            Action<ItemBase> actionOnGet = null,
            Action<ItemBase> actionOnRelease = null,
            Action<ItemBase> actionOnDestroy = null,
            bool collectionCheck = true,
            int defaultCapacity = 10,
            int maxSize = 100) : base(createFunc, actionOnGet, actionOnRelease, actionOnDestroy, collectionCheck, defaultCapacity, maxSize)
    { }
}
