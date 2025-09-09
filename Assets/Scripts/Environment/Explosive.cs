using System.Collections;
using UnityEngine;
using UnityEngine.Events;

public class Explosive : MonoBehaviour
{
    [SerializeField] private float _range;
    [SerializeField] private float _explosionForce;
    [SerializeField] private float _damage;
    [SerializeField] private LayerMask _playersLayer;
    [SerializeField] private LayerMask _toysLayer;
    [SerializeField] private float _signalDuration;
    [SerializeField] private float _beepingRate;
    [SerializeField] private UnityEvent _shakeit;
    [SerializeField] private GameObject _mineMesh;
    private bool _countdown;
    private Material _mineMat;

    private void Start()
    {
        if (_mineMesh != null)
        { 
            _mineMat = _mineMesh.GetComponent<Renderer>().material;
        }
    }
    void Explode()
    {
        _shakeit?.Invoke();
        AudioManager.PlaySound(TypeOfSound.Explosion);
        Collider[] toysColliders = Physics.OverlapSphere(transform.position, _range, _toysLayer);
        for (int i = 0; i < toysColliders.Length; i++)
        {
            Rigidbody targetRigidbody = toysColliders[i].GetComponent<Rigidbody>();
            if (!targetRigidbody)
                continue;
            targetRigidbody.AddExplosionForce(_explosionForce, transform.position, _range);
        }

            Collider[] colliders = Physics.OverlapSphere(transform.position, _range, _playersLayer);
        {
            for (int i = 0; i < colliders.Length; i++)
            {
                Rigidbody targetRigidbody = colliders[i].GetComponent<Rigidbody>();
                if (!targetRigidbody)
                    continue;

                targetRigidbody.AddExplosionForce(_explosionForce, transform.position, _range);

                HealthManager targetHealth = targetRigidbody.GetComponent<HealthManager>();

                if (!targetHealth)
                    continue;

                targetHealth.DoDamage(_damage);
            }
            Destroy(gameObject);
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.gameObject.layer == LayerMask.NameToLayer("Projectiles"))
        {
            Explode();
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if ((_playersLayer.value & (1 << other.gameObject.layer)) != 0)
        {
            AudioManager.PlaySound(TypeOfSound.Mine);
            StartCoroutine(MineSignal());
            StartCoroutine(ToggleLight());
        }
    }

    IEnumerator MineSignal()
    {
        yield return new WaitForSeconds(_signalDuration);
        _countdown = true;
        Explode();
    }

    IEnumerator ToggleLight()
    {
        float span = _signalDuration;

        while (!_countdown)
        {
            _mineMat.EnableKeyword("_EMISSION");

            yield return new WaitForSeconds(.2F);

            _mineMat.DisableKeyword("_EMISSION");

            yield return new WaitForSeconds(.2F);
        }

        //do
        //{


        //    //span = span - (_signalDuration / 10);
        //} while (!_countdown);
    }
}
