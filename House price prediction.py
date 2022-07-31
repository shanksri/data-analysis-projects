#!/usr/bin/env python
# coding: utf-8

# In[2]:


import numpy as np
import pandas as pd


# In[3]:


import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname,filename))


# In[4]:


df_train = pd.read_csv(r'C:\Users\shash\Downloads\train.csv')
df_test  = pd.read_csv(r'C:\Users\shash\Downloads\test.csv')


# In[5]:


base_path = '../input/house-prices-advanced-regression-techniques'


# In[6]:


df_train


# In[7]:


df_test.head()


# In[8]:


print(df_train.columns)


# In[9]:


features = ['MSZoning', 'LotArea', 'Street', 'Utilities', 'LotConfig', 'LandSlope',
       'Neighborhood', 'YearBuilt', 'YearRemodAdd', 'RoofStyle', 'RoofMatl', 'ExterQual', 
            'Foundation',  'Electrical', 'FullBath', 'HalfBath', 'BedroomAbvGr', 'KitchenAbvGr',
        'GarageType', 'GarageCars', 'GarageArea', 'MoSold', 'YrSold',
            'SaleType', 'SaleCondition', 'SalePrice'
           ]


# In[10]:


data = df_train[features]


# In[11]:


data.isna().sum()


# In[12]:


data.head()


# In[13]:


import matplotlib.pyplot as plt
import numpy as np


# In[14]:


columns = ['YrSold','SalePrice']
df_pivot = data[columns]
year_sales = df_pivot.groupby('YrSold').agg(['sum','min','mean','max'])
year_sales


# In[15]:


year_sales.columns


# In[16]:


year_sales.plot(kind = 'line', y =('SalePrice','sum'),color ='r', title = 'SalesPrice')


# In[17]:


columns = ['Neighborhood', 'YrSold', 'SalePrice']
df_pivot = data[columns]
year_sales = pd.DataFrame(df_pivot.groupby(['Neighborhood', 'YrSold']).SalePrice.sum())
year_sales


# In[18]:


year_sales.reset_index(level='Neighborhood', inplace=True)
year_sales


# In[45]:


df_pivot = pd.pivot_table(year_sales, index = year_sales.index,columns = ['Neighborhood'])
df_pivot


# In[30]:


df_pivot.plot(kind = 'bar',figsize=(15,10))


# In[42]:


columns = ['Neighborhood','SalePrice']
dfnew = data[columns]
dfnew = pd.DataFrame(dfnew.groupby('Neighborhood').SalePrice.sum())
dfnew = dfnew.sort_values(by='SalePrice',ascending=False)
dfnew = dfnew[:10]


# In[43]:


dfnew.head()


# In[52]:


ax = dfnew.plot(kind='bar',title='\nNeighborhood Sales' , rot=0,figsize=(9,5), color='b')
ax.set_ylabel('Price($)')  #used rot make neighborhood look horizontal
plt.show()


# In[53]:


##Analysing the features


# In[54]:


import seaborn as sns


# In[56]:


corr = data.corr()
fig,ax = plt.subplots(figsize=(10,10))
sns.heatmap(corr,annot=True,ax=ax)


# In[59]:


##visualizing prices for each feature with high correlatinon with salePrice
corr.loc[['SalePrice']]


# In[66]:


feats = []
line = corr.loc[['SalePrice']]
for c in corr.columns:
    if line[c][0] > 0.5 and line[c][0] < 1:
        feats.append(c)
feats.append('SalePrice')


# In[67]:


df_ = data[feats]
df_.head()


# In[ ]:


for f in feats[2:-1]:
    plt.close()
    df_pivot = pd.DataFrame(df_.groupby(f).SalePrice.sum())
    df_pivot = pd.pivot_table(df_pivot, index=df_pivot.index, columns=[f], aggfunc='first')
    ax = df_pivot.plot(kind='bar', title=f'{f} Sales', rot=0, figsize=(9,5), color='b')
    ax.set_ylabel('Price ($)')
    plt.show()


# In[69]:


data.dtypes


# In[ ]:





# In[73]:


len(data.columns)


# In[ ]:




