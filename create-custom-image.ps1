$resourceGroupName = 'Images'
$targetRG = $resourceGroupName # Could specify a different resource group
$location = 'EastUS'
$VMName = 'Win10'
$imageName = $VMName
$publisher = 'MelloSec'
$offer = 'Desktop'
$sku = 'Win10Base'

$sourceVM = Get-AzVM `
   -Name $VMName `
   -ResourceGroupName $targetRG

$resourceGroup = New-AzResourceGroup `
   -Name $resourceGroupName `
   -Location $location

$gallery = New-AzGallery `
   -GalleryName 'TestGallery' `
   -ResourceGroupName $resourceGroupName.ResourceGroupName `
   -Location $resourceGroupName.Location `
   -Description 'Test Azure Compute Gallery for MelloSec'

$galleryImage = New-AzGalleryImageDefinition `
   -GalleryName $gallery.Name `
   -ResourceGroupName $resourceGroupName.ResourceGroupName `
   -Location $gallery.Location `
   -Name $VMName `
   -OsState generalized `
   -OsType Windows `
   -Publisher $publisher `
   -Offer $offer `
   -Sku $sku

$region1 = @{Name='East US';ReplicaCount=1}
$targetRegions = @($region1)

New-AzGalleryImageVersion `
   -GalleryImageDefinitionName $galleryImage.Name`
   -GalleryImageVersionName '0.0.1' `
   -GalleryName $gallery.Name `
   -ResourceGroupName $resourceGroupName.ResourceGroupName `
   -Location $resourceGroup.Location `
   -TargetRegion $targetRegions  `
   -Source $sourceVM.Id.ToString() `
   -PublishingProfileEndOfLifeDate '2030-12-01'