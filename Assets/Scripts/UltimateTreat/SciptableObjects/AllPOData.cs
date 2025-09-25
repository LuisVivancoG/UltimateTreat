using UnityEngine;

[CreateAssetMenu(fileName = "PO Container", menuName = "Create Scriptable Objects/All PO Data")]
public class AllPOData : ScriptableObject
{
    [SerializeField] private SOData[] _data;
    public SOData[] Data => _data;
}
