using UnityEngine;

[CreateAssetMenu(fileName = "SO Data", menuName = "Create Scriptable Objects/Single SO Data")]

public class SOData : ScriptableObject
{
    [SerializeField] private PooledAsset _objectPrefab;
    [SerializeField] private string _objectName;
    [SerializeField] private SOType _objectType;
    //[SerializeField] private Sprite _objectSprite;
    //[SerializeField] private float _timeBeforeConsume;
    //[SerializeField] private bool _isSingleUse;
    //[SerializeField] private float _reuseCooldown;
    //[SerializeField] private bool _isProjectile;
    //[SerializeField] private float _speed;
    //[SerializeField] private float _hpModifier;
    //[SerializeField] private bool _canRicochet;

    public PooledAsset ObjectPrefab => _objectPrefab;
    public string ObjectName => _objectName;
    public SOType ObjectType => _objectType;
    //public Sprite ObjectSprite => _objectSprite;
}
