const { test, expect } = require('@playwright/test');
const { baseUrl } = require('../dados/acesso.json');
const { productName, targetQuantity } = require('../dados/carrinho.json');

test.use({ baseURL: baseUrl });

test('Adicionar até 5 unidades do mesmo produto', async ({ page }) => {
  await page.goto('/');
  await page
    .getByRole('article', { name: productName })
    .getByRole('button', { name: 'Adicionar ao carrinho' })
    .click();
  await page.getByRole('link', { name: /Carrinho/ }).click();

  const aumentar = page.getByRole('button', {
    name: `Aumentar quantidade de ${productName}`,
  });
  for (let i = 1; i < targetQuantity; i++) {
    await aumentar.click();
  }

  await expect(
    page.getByRole('status', { name: `Quantidade de ${productName}` })
  ).toHaveText(String(targetQuantity));
});