using UnityEngine;

public class CharacterShooting : MonoBehaviour
{
    [SerializeField] private Transform _spawnerLoc;
    [SerializeField] private float _forceSpeed = 20f;

    public Transform SpawnerLoc => _spawnerLoc;

    public void Fire()
    {
        var projectile = PoolsManagment.Instance.GetObject(SOType.BasicProjectile, SpawnerLoc);
        projectile.TryGetComponent<Rigidbody>(out Rigidbody rb);
        rb.linearVelocity = SpawnerLoc.forward * _forceSpeed;
    }
}
