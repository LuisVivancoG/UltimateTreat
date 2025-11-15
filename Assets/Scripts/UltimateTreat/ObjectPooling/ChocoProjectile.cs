using UnityEngine;

public class ChocoProjectile : ProjectileBase
{
    [SerializeField] private SOType _decalType = SOType.ChocoSplatter;

    internal override void SetProjectile()
    {
        base.SetProjectile();

        transform.localScale = RandomSize();
    }

    Vector3 RandomSize()
    {
        var randomNum = Random.Range(0.35f, 2f);
        Vector3 size = new Vector3(randomNum, randomNum, randomNum);
        return size;
    }

    internal override void ProcessEffects(Vector3 contactP, Vector3 contactN)
    {
        base.ProcessEffects(contactP, contactN);

        Quaternion rot = Quaternion.LookRotation(-contactN);
        PoolsManagment.Instance.GetObject(_decalType, contactP, rot.eulerAngles);
    }
}
