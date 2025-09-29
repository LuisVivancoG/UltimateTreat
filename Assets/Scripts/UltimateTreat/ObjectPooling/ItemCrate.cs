using UnityEngine;
using UnityEngine.UI;

public class ItemCrate : PooledAsset
{
    private PooledAsset _prefab;
    private Image _iconDisplayed;
    private Text _textDisplayed;

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.TryGetComponent<CharacterShooting>(out var player))
        {
            returnItem();
            //player._currentPower = _prefab.SOData.ObjectType;
        }
    }
}
