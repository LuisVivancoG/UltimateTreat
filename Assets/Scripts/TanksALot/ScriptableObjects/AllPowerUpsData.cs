using UnityEngine;

[CreateAssetMenu(fileName = "ItemsData", menuName = "Create Scriptable Objects/All Items Data")]
public class AllItemsData : ScriptableObject
{
    [SerializeField] private ItemData[] _data;
    public ItemData[] Data => _data;
}
