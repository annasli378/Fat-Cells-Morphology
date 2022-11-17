# -*- coding: utf-8 -*-
"""
Created on Wed Nov 16 15:29:32 2022

@author: Ania
"""


# IMPORTY
import os
import numpy as np 
import pandas as pd 
import glob
#import openslide
import matplotlib.pyplot as plt
import cv2,math,sys,time,os
from tqdm import tqdm
import itertools
import warnings
from scipy.spatial import Delaunay, delaunay_plot_2d, Voronoi, voronoi_plot_2d
#%% FUNKCJE
def water_shed(gray_img,color_img,p=0.1):
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
    sure_bg = cv2.dilate(gray_img, kernel, iterations=2)## はいぱら
    dist = cv2.distanceTransform(gray_img, cv2.DIST_L2, 5)
    ret, sure_fg = cv2.threshold(dist, p * dist.max(), 255, cv2.THRESH_BINARY)
    sure_fg = sure_fg.astype(np.uint8)
    #fig = plt.figure(figsize=(20,20))
    #plt.imshow(dist,cmap="gray")
    #plt.show()
    unknown = cv2.subtract(sure_bg, sure_fg)
    n_labels, markers = cv2.connectedComponents(sure_fg)
    """
    fig = plt.figure(figsize=(20,20))
    plt.imshow(markers)
    plt.show()
    """
    markers += 1
    markers[unknown == 255] = 0
    markers = cv2.watershed(color_img, markers)
    return markers

def img_and(mask,canny):  # uint8 ndarray0~255
    canny = (255-canny)/255
    mask = mask/255
    
    new_img = np.logical_and(canny,mask)
    return new_img

def each_cell_vori(markers,thresh=0.03,plot=True):
    u, counts = np.unique(markers.ravel(), return_counts=True)
    areas = []
    emp = np.zeros_like(markers)
    margin_num = 0
    points = []##ボロノイ分割よう
    ellipses  = []
    ellipses_rate = []
    emp_2 = np.zeros_like(markers)
    
    for cls,s in zip(u,counts):
        if cls<0:
            """
            tmp_img = (markers == cls)
            plt.imshow(tmp_img)
            plt.show()
            """
            continue#枠(-1)
        if s<500:continue
        if s >1024*1024*thresh:
            if plot:
                tmp_img = (markers == cls)
                plt.title(f"class{cls} area{s}")
                plt.imshow(tmp_img)
                plt.show()
            margin_num+=1
            continue#大きい余白を除く
        tmp_img = (markers == cls)
        emp[np.where(markers == cls)]=cls
        ### 距離計測
        emp_2[np.where(markers == cls)]=cls
        mu = cv2.moments(emp_2.astype("uint8"), False)
        try:
            x,y= int(mu["m10"]/mu["m00"]) , int(mu["m01"]/mu["m00"])
            points.append([x,y])
        except Exception as e:
            print("center not...")
            x,y = (0,0)
            points.append([x,y])

        
        contours, hierarchy = cv2.findContours(emp_2.astype("uint8"),cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)#RETR_LIST
        #print("~~~~",len(contours))
        

        mx_area = 0
        for cont in contours:
            
            x_,y_,w,h = cv2.boundingRect(cont)
            area = w*h
        
            if area > mx_area:
                mx = x_,y_,w,h
                mx_area = area
                if area<10 or len(cont)<5:continue
                try:
                    ellipse = cv2.fitEllipse(cont)

                except Exception as e:
                    print(len(cont))
           # ellipse_h = ellipse[1][0]
           # ellipse_w = ellipse[1][1]

        try:
            ellipses.append([ellipse[1][0],ellipse[1][1]])
            ellipses_rate.append(ellipse[1][0]/ellipse[1][1])##h/w
        except Exception as e:
            print(e)
            #sys.exit()
        
        emp_2 = cv2.circle(emp_2, (x,y), 4, 100, 2, 4)
        emp_2[np.where(markers == cls)]=0
        
        
        if cls%200==0 and plot:
            plt.title(f"class{cls} area{s}")
            plt.imshow(tmp_img)
            plt.show()
        areas.append(s)
        #if cls>20:break
    back_area = counts[2]
    

    for xy in  points:
        x = xy[0]
        y =xy[1]        
        emp = cv2.circle(emp, (x,y), 4, 100, 2, 4)

    norms = []
    try:
        tri = Delaunay(points)
        tri_points = tri.points
        
        for i in range(len(tri_points)):
            for j in range(i,len(tri_points)):
                if i==j:continue
                x_i = tri_points[i][0]
                y_i = tri_points[i][1]
                x_j = tri_points[j][0]
                y_j = tri_points[j][1]
                nolm = ((x_i-x_j)**2+(y_i-y_j)**2)**0.5
                norms.append(nolm)
    except Exception as e:
        plt.imshow(emp)
        plt.savefig("error.png")
        plt.imshow(markers)
        plt.savefig("error1.png")
    return emp,areas,back_area,margin_num,norms,ellipses_rate
