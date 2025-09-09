using UnityEngine;
using UnityEngine.UI;

public class UIManager : MonoBehaviour
{
    [SerializeField] private Image _itemSprite;
    [SerializeField] private Slider _hpSlider;
    [SerializeField] private GameObject _firstStar;
    [SerializeField] private GameObject _secondStar;
    [SerializeField] private GameObject _thirdStar;
    private float _currentSliderValue;
    private float _maxHp;
    private float _currentHp;

    public void AddStar(int x)
    {
        if (x == 1)
        {
            _firstStar.SetActive(true);
        }
        if (x == 2)
        {
            _secondStar.SetActive(true);
        }
        if (x == 3)
        {
            _firstStar.SetActive(true);
        }
    }

    internal void SetUpSlider(float playerHP)
    {
        _maxHp = playerHP;
        _hpSlider.value = 1;
    }

    public void UpdateHpSlider(float newHp)
    {
        _currentHp = newHp;
        _hpSlider.value = ConvertAndClampHP();
    }

    float ConvertAndClampHP()
    {
         return Mathf.Clamp(_currentHp / _maxHp, 0, 1);
    }

    public void UpdateCurrentAbility(Sprite currentItem)
    {
        _itemSprite.enabled = true;
        _itemSprite.sprite = currentItem;
    }

    public void RestoreDefaultAbility()
    {
        _itemSprite.enabled = false;
    }
}
