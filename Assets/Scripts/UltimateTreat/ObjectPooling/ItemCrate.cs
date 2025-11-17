using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

public class ItemCrate : PooledAsset
{
    [SerializeField] SOType _powerUp;

    private PooledAsset _prefab;
    private Image _iconDisplayed;
    private Text _textDisplayed;

    private void OnEnable()
    {
        transform.localScale = new Vector3(.2f, .2f, .2f);
        transform.DOScale(Vector3.one, 1f);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.TryGetComponent<CharacterShooting>(out var player))
        {
            switch (_powerUp)
            {
                case SOType.ChocoProjectile:
                    player._queueHability = SOType.ChocoProjectile;
                    player.HasItem = true;
                    break;

                case SOType.RollerProjectile:
                    player._queueHability = SOType.RollerProjectile;
                    player.HasItem = true;
                    break;
                case SOType.CottonProjectile:
                    player._queueHability = SOType.ChocoProjectile;
                    player.HasItem = true;
                    break;
                case SOType.HealPack:
                    player._queueHability = SOType.HealPack;
                    break;
            }
                

            returnItem();
        }
    }
}
